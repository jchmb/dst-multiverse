local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_build.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_trunk_build.zip"),
    Asset("MINIMAP_IMAGE", "minimap_saptree.tex"),
    -- Asset("MINIMAP_IMAGE", "quagmire_sugarwoodtree_stump"),
    -- Asset("MINIMAP_IMAGE", "quagmire_sugarwoodtree_tapped"),
}

local prefabs =
{
    "log",
    "twigs",
    -- "quagmire_sap",
    -- "quagmire_sap_spoiled",
    "sugarwood_leaf_fx",
    "sugarwood_leaf_fx_chop",
    "sugarwood_leaf_withered_fx",
    "sugarwood_leaf_withered_fx_chop",
}

local DEFAULT_TREE_DEF = 2
local TREE_DEFS =
{
    {
        prefab_name = "saptree_small",
        anim_file = "quagmire_tree_cotton_short",
        loot = {
            "log"
        },
    },
    {
        prefab_name = "saptree_normal",
        anim_file = "quagmire_tree_cotton_normal",
        loot = {
            "log",
            "log",
        },
    },
    {
        prefab_name = "saptree_tall",
        anim_file = "quagmire_tree_cotton_tall",
        loot = {
            "log",
            "log",
            "log",
        },
    },
}

for i, v in ipairs(TREE_DEFS) do
    table.insert(assets, Asset("ANIM", "anim/"..v.anim_file..".zip"))
end

local function SetStage(inst, stage)
    stage = stage or DEFAULT_TREE_DEF
    inst.stage = stage
    inst.AnimState:SetBank(TREE_DEFS[stage].anim_file)
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.components.lootdropper:SetLoot(TREE_DEFS[stage].loot)
end

local function OnLoad(inst, data)
    if not data then
        return
    end
    if data.stage then
        SetStage(inst, data.stage)
    end
end

local function OnSave(inst, data)
    if not data then
        return
    end
    if inst.stage then
        data.stage = inst.stage
    end
end

local function PushSway(inst, skippre)
    inst.AnimState:PushAnimation(math.random() < .5 and "sway1_loop" or "sway2_loop", true)
end

local function DigUpStump(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function ChopDownTreeShake(inst)
    ShakeAllCameras(
        CAMERASHAKE.FULL,
        .25,
        .03,
        inst.components.growable ~= nil and inst.components.growable.stage > 2 and .5 or .25,
        inst,
        6
    )
end

local function ChopTree(inst, chopper, chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(
            chopper ~= nil and chopper:HasTag("beaver") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            "dontstarve/wilson/use_axe_tree"
        )
    end

    -- SpawnLeafFX(inst, nil, true)

    -- Force update anims if monster
    inst.AnimState:PlayAnimation("chop")

    PushSway(inst)
end

local function MakeStump(inst)
    inst:RemoveComponent("burnable")
    MakeSmallBurnable(inst)
    inst:RemoveComponent("propagator")
    MakeSmallPropagator(inst)
    inst:RemoveComponent("workable")
    inst:RemoveTag("shelter")
    inst:RemoveTag("cattoyairborne")
    inst:AddTag("stump")

    -- TODO
    -- inst.MiniMapEntity:SetIcon("tree_leaf_stump.png")

    -- if inst.monster_start_task ~= nil then
    --     inst.monster_start_task:Cancel()
    --     inst.monster_start_task = nil
    -- end
    -- if inst.monster_stop_task ~= nil then
    --     inst.monster_stop_task:Cancel()
    --     inst.monster_stop_task = nil
    -- end
    -- if inst.leaveschangetask ~= nil then
    --     inst.leaveschangetask:Cancel()
    --     inst.leaveschangetask = nil
    -- end
    -- if inst.leaveschangetask ~= nil then
    --     inst.leaveschangetask:Cancel()
    --     inst.leaveschangetask = nil
    -- end

    RemovePhysicsColliders(inst)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(DigUpStump)
    inst.components.workable:SetWorkLeft(1)

    if inst.components.growable ~= nil then
        inst.components.growable:StopGrowing()
    end

    -- if inst.components.timer ~= nil and not inst.components.timer:TimerExists("decay") then
    --     inst.components.timer:StartTimer("decay", GetRandomWithVariance(TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME, TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME * .5))
    -- end:AddOverrideBuild
end

local function GetStatus(inst)
    return "NORMAL"
end

local function ChopDownTree(inst, chopper)
    local days_survived = TheWorld.state.cycles

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")


    local pt = inst:GetPosition()
    local hispos = chopper:GetPosition()
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    if he_right then
        inst.AnimState:PlayAnimation("fallleft")
        if inst.components.growable ~= nil and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("acorn", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright")
        if inst.components.growable ~= nil and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("acorn", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    inst:DoTaskInTime(.4, ChopDownTreeShake)

    inst.AnimState:PushAnimation("stump")

    MakeStump(inst)
end

local function fn(tree_def)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

    minimap:SetIcon("minimap_saptree.tex")
    minimap:SetPriority(1)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst:AddTag("tree")
    inst:AddTag("shelter")
    inst:AddTag("saptree")
    inst:AddTag("tappable")

    inst.AnimState:SetBank(TREE_DEFS[tree_def or DEFAULT_TREE_DEF].anim_file)
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_sapbucket")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap") -- wounded sap marks
    inst.AnimState:PlayAnimation("sway1_loop", true)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
    inst.components.burnable:SetFXLevel(5)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetOnWorkCallback(ChopTree)
    inst.components.workable:SetOnFinishCallback(ChopDownTree)

    inst:AddComponent("lootdropper")

    -- inst:AddComponent("tappable")
    -- inst.components.tappable:SetPrefab("sap")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    -- event_server_data("quagmire", "prefabs/quagmire_sugarwoodtree").master_postinit(inst, tree_def, TREE_DEFS)

    return inst
end

local function MakeTree(i, name, _assets, _prefabs)
    local function _fn()
        local inst = fn(i)
        if not TheWorld.ismastersim then
            return inst
        end
        SetStage(inst, i)
        inst:SetPrefabName("saptree")
        return inst
    end

    return Prefab(name, _fn, _assets, _prefabs)
end

local tree_prefabs = {}
for i, v in ipairs(TREE_DEFS) do
    table.insert(tree_prefabs, MakeTree(i, v.prefab_name))
    table.insert(prefabs, v.prefab_name)
end

table.insert(tree_prefabs, MakeTree(nil, "saptree", assets, prefabs))

return unpack(tree_prefabs)
