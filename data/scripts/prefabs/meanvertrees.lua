local assets =
{
    Asset("ANIM", "anim/tree_leaf_short.zip"),
    Asset("ANIM", "anim/tree_leaf_normal.zip"),
    Asset("ANIM", "anim/tree_leaf_tall.zip"),
    Asset("ANIM", "anim/tree_leaf_trunk_build.zip"), --trunk build (winter leaves build)
    Asset("ANIM", "anim/tree_leaf_green_build.zip"), --spring, summer leaves build
    Asset("ANIM", "anim/tree_leaf_red_build.zip"), --autumn leaves build
    Asset("ANIM", "anim/tree_leaf_orange_build.zip"), --autumn leaves build
    Asset("ANIM", "anim/tree_leaf_yellow_build.zip"), --autumn leaves build
    Asset("ANIM", "anim/tree_leaf_poison_build.zip"), --poison leaves build
    Asset("SOUND", "sound/forest.fsb"),
    Asset("SOUND", "sound/deciduous.fsb"),
    Asset("MINIMAP_IMAGE", "tree_leaf"),
    Asset("MINIMAP_IMAGE", "tree_leaf_burnt"),
    Asset("MINIMAP_IMAGE", "tree_leaf_stump"),
}

local prefabs =
{
    "log",
    "twigs",
    "acorn",
    "charcoal",
    "green_leaves",
    "red_leaves",
    "orange_leaves",
    "yellow_leaves",
    "purple_leaves",
    "green_leaves_chop",
    "red_leaves_chop",
    "orange_leaves_chop",
    "yellow_leaves_chop",
    "purple_leaves_chop",
    "deciduous_root",
    "livinglog",
    "nightmarefuel",
    "spoiled_food",
    "birchnutdrake"
}

local builds =
{
    normal = { --Green
        leavesbuild="tree_leaf_green_build",
        prefab_name="meanvertree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="green_leaves",
        chopfx="green_leaves_chop",
        shelter=true,
    },
    barren = {
        leavesbuild=nil,
        prefab_name="meanvertree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log"},
        drop_acorns=false,
        fx=nil,
        chopfx=nil,
        shelter=false,
    },
    red = {
        leavesbuild="tree_leaf_red_build",
        prefab_name="meanvertree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="red_leaves",
        chopfx="red_leaves_chop",
        shelter=true,
    },
    orange = {
        leavesbuild="tree_leaf_orange_build",
        prefab_name="meanvertree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="orange_leaves",
        chopfx="orange_leaves_chop",
        shelter=true,
    },
    yellow = {
        leavesbuild="tree_leaf_yellow_build",
        prefab_name="meanvertree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="yellow_leaves",
        chopfx="yellow_leaves_chop",
        shelter=true,
    },
}

local function makeanims(stage)
    return {
            idle="idle_"..stage,
            sway1="sway1_loop_"..stage,
            sway2="sway2_loop_"..stage,
            swayaggropre="sway_agro_pre",
            swayaggro="sway_loop_agro",
            swayaggropst="sway_agro_pst",
            swayaggroloop="idle_loop_agro",
            swayfx="swayfx_"..stage,
            chop="chop_"..stage,
            fallleft="fallleft_"..stage,
            fallright="fallright_"..stage,
            stump="stump_"..stage,
            burning="burning_loop_"..stage,
            burnt="burnt_"..stage,
            chop_burnt="chop_burnt_"..stage,
            idle_chop_burnt="idle_chop_burnt_"..stage,
            dropleaves = "drop_leaves_"..stage,
            growleaves = "grow_leaves_"..stage,
        }
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local normal_anims = makeanims("normal")

local function GetBuild(inst)
    return builds[inst.build] or build.normal
end

local function SpawnLeafFX(inst, waittime, chop)
    if (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or
        inst:HasTag("stump") or
        inst:HasTag("burnt") or
        inst:IsAsleep() then
        return
    elseif waittime ~= nil then
        inst:DoTaskInTime(waittime, SpawnLeafFX, nil, chop)
        return
    end

    local fx = nil
    if chop then
        if GetBuild(inst).chopfx ~= nil then
            fx = SpawnPrefab(GetBuild(inst).chopfx)
        end
    elseif GetBuild(inst).fx ~= nil then
        fx = SpawnPrefab(GetBuild(inst).fx)
    end
    if fx ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        if inst.components.growable ~= nil then
            if inst.components.growable.stage == 1 then
                --y = y + 0 --Short FX height
            elseif inst.components.growable.stage == 2 then
                y = y - .3 --Normal FX height
            elseif inst.components.growable.stage == 3 then
                --y = y + 0 --Tall FX height
            end
        end
        --Randomize height a bit for chop FX
        fx.Transform:SetPosition(x, chop and y + math.random() * 2 or y, z)
    end
end

local function PushSway(inst, monster, monsterpost, skippre)
    if monster then
        inst.sg:GoToState("gnash_pre", { push = true, skippre = skippre })
    elseif monsterpost then
        inst.sg:GoToState(inst.sg:HasStateTag("gnash") and "gnash_pst" or "gnash_idle")
    elseif inst.monster then
        inst.sg:GoToState("gnash_idle")
    else
        inst.AnimState:PushAnimation(math.random() < .5 and inst.anims.sway1 or inst.anims.sway2, true)
    end
end

local function Sway(inst, monster, monsterpost)
    if inst.sg:HasStateTag("burning") or inst:HasTag("stump") then
        return
    elseif monster then
        inst.sg:GoToState("gnash_pre", { push = false, skippre = false })
    elseif monsterpost then
        inst.sg:GoToState(inst.sg:HasStateTag("gnash") and "gnash_pst" or "gnash_idle")
    elseif inst.monster then
        inst.sg:GoToState("gnash_idle")
    else
        inst.AnimState:PlayAnimation(math.random() < .5 and inst.anims.sway1 or inst.anims.sway2, true)
    end
end

local function GrowLeavesFn(inst, monster, monsterout)
    if (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or
        inst:HasTag("stump") or
        inst:HasTag("burnt") then
        inst:RemoveEventCallback("animover", GrowLeavesFn)
        return
    end

    if inst.leaf_state == "barren" or inst.target_leaf_state == "barren" then
        inst:RemoveEventCallback("animover", GrowLeavesFn)
        if inst.target_leaf_state == "barren" then
            inst.build = "barren"
        end
    end

    if GetBuild(inst).leavesbuild then
        inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
    else
        inst.AnimState:ClearOverrideSymbol("swap_leaves")
    end

    if inst.components.growable ~= nil then
        if inst.components.growable.stage == 1 then
            inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
        elseif inst.components.growable.stage == 2 then
            inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
        else
            inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
        end
    end

    inst.leaf_state = inst.target_leaf_state
    if inst.leaf_state == "barren" then
        inst.AnimState:ClearOverrideSymbol("mouseover")
    else
        if inst.build == "barren" then
            inst.build = inst.leaf_state == "normal" and "normal" or "red"
        end
        inst.AnimState:OverrideSymbol("mouseover", "tree_leaf_trunk_build", "toggle_mouseover")
    end

    if monster ~= true and monsterout ~= true then
        Sway(inst)
    end
end

local function OnChangeLeaves(inst, monster, monsterout)
    if (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or
        inst:HasTag("stump") or
        inst:HasTag("burnt") then
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
        return
    elseif not monster and inst.components.workable and inst.components.workable.lastworktime and inst.components.workable.lastworktime < GetTime() - 10 then
        inst.targetleaveschangetime = GetTime() + 11
        inst.leaveschangetask = inst:DoTaskInTime(11, OnChangeLeaves)
        return
    else
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
    end

    if inst.target_leaf_state ~= "barren" then
        if inst.target_leaf_state == "colorful" then
            local rand = math.random()
            inst.build = ({ "red", "orange", "yellow" })[math.random(3)]
            inst.AnimState:SetMultColour(1, 1, 1, 1)
        elseif inst.target_leaf_state == "poison" then
            inst.AnimState:SetMultColour(1, 1, 1, 1)
            inst.build = "poison"
        else
            inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
            inst.build = "normal"
        end

        if inst.leaf_state == "barren" then
            if GetBuild(inst).leavesbuild then
                inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
            else
                inst.AnimState:ClearOverrideSymbol("swap_leaves")
            end
            inst.AnimState:PlayAnimation(inst.anims.growleaves)
            inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
            inst:ListenForEvent("animover", GrowLeavesFn)
        else
            GrowLeavesFn(inst, monster, monsterout)
        end
    else
        inst.AnimState:PlayAnimation(inst.anims.dropleaves)
        SpawnLeafFX(inst, 11 * FRAMES)
        inst.SoundEmitter:PlaySound("dontstarve/forest/treeWilt")
        inst:ListenForEvent("animover", GrowLeavesFn)
    end
    if GetBuild(inst).shelter then
        inst:AddTag("shelter")
    else
        inst:RemoveTag("shelter")
    end
end

local function ChangeSizeFn(inst)
    inst:RemoveEventCallback("animover", ChangeSizeFn)
    if inst.components.growable ~= nil then
        inst.anims =
            (inst.components.growable.stage == 1 and short_anims) or
            (inst.components.growable.stage == 2 and normal_anims) or
            (inst.monster and monster_anims) or
            tall_anims
    end
    Sway(inst, nil, inst.monster)
end

local function SetShort(inst)
    if not inst.monster then
        inst.anims = short_anims
        if inst.components.workable ~= nil then
           inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_SMALL)
        end
        inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
    end
end

local function GrowShort(inst)
    if not inst.monster then
        inst.AnimState:PlayAnimation("grow_tall_to_short")
        if inst.leaf_state == "colorful" then
            SpawnLeafFX(inst, 17 * FRAMES)
        end
        inst:ListenForEvent("animover", ChangeSizeFn)
        inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    end
end

local function SetNormal(inst)
    inst.anims = normal_anims
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_NORMAL)
    end
    inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
end

local function GrowNormal(inst)
    inst.AnimState:PlayAnimation("grow_short_to_normal")
    if inst.leaf_state == "colorful" then
        SpawnLeafFX(inst, 10 * FRAMES)
    end
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local function SetTall(inst)
    inst.anims = tall_anims
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_TALL)
    end
    inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
end

local function GrowTall(inst)
    inst.AnimState:PlayAnimation("grow_normal_to_tall")
    if inst.leaf_state == "colorful" then
        SpawnLeafFX(inst, 10 * FRAMES)
    end
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local growth_stages =
{
    { name = "short", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[1].base, TUNING.DECIDUOUS_GROW_TIME[1].random) end, fn = SetShort, growfn = GrowShort },
    { name = "normal", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[2].base, TUNING.DECIDUOUS_GROW_TIME[2].random) end, fn = SetNormal, growfn = GrowNormal },
    { name = "tall", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[3].base, TUNING.DECIDUOUS_GROW_TIME[3].random) end, fn = SetTall, growfn = GrowTall },
    --{ name = "old", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[4].base, TUNING.DECIDUOUS_GROW_TIME[4].random) end, fn = SetOld, growfn = GrowOld },
}

local function chop_tree(inst, chopper, chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(
            chopper ~= nil and chopper:HasTag("beaver") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            "dontstarve/wilson/use_axe_tree"
        )
    end

    SpawnLeafFX(inst, nil, true)

    -- Force update anims if monster
    inst.AnimState:PlayAnimation(inst.anims.chop)

    PushSway(inst)
end

local function dig_up_stump(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function chop_down_tree_shake(inst)
    ShakeAllCameras(
        CAMERASHAKE.FULL,
        .25,
        .03,
        inst.components.growable ~= nil and inst.components.growable.stage > 2 and .5 or .25,
        inst,
        6
    )
end

local function make_stump(inst)
    inst:RemoveComponent("burnable")
    MakeSmallBurnable(inst)
    inst:RemoveComponent("propagator")
    MakeSmallPropagator(inst)
    inst:RemoveComponent("workable")
    inst:RemoveTag("shelter")
    inst:RemoveTag("cattoyairborne")
    inst:AddTag("stump")

    inst.MiniMapEntity:SetIcon("tree_leaf_stump.png")

    if inst.monster_start_task ~= nil then
        inst.monster_start_task:Cancel()
        inst.monster_start_task = nil
    end
    if inst.monster_stop_task ~= nil then
        inst.monster_stop_task:Cancel()
        inst.monster_stop_task = nil
    end
    if inst.leaveschangetask ~= nil then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end
    if inst.leaveschangetask ~= nil then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end

    RemovePhysicsColliders(inst)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)

    if inst.components.growable ~= nil then
        inst.components.growable:StopGrowing()
    end

    if inst.components.timer ~= nil and not inst.components.timer:TimerExists("decay") then
        inst.components.timer:StartTimer("decay", GetRandomWithVariance(TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME, TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME * .5))
    end
end

local function chop_down_tree(inst, chopper)
    local days_survived = TheWorld.state.cycles

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    local pt = inst:GetPosition()
    local hispos = chopper:GetPosition()
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    if he_right then
        inst.AnimState:PlayAnimation(inst.anims.fallleft)
        if inst.components.growable ~= nil and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("acorn", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation(inst.anims.fallright)
        if inst.components.growable ~= nil and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("acorn", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    inst:DoTaskInTime(.4, chop_down_tree_shake)

    inst.AnimState:PushAnimation(inst.anims.stump)

    make_stump(inst)
end

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
    RemovePhysicsColliders(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
    if inst.acorntask ~= nil then
        inst.acorntask:Cancel()
        inst.acorntask = nil
    end
end

local function _onburntchanges2(inst)
    if inst.components.burnable ~= nil and inst.components.propagator ~= nil then
        inst.components.burnable:Extinguish()
        inst.components.propagator:StopSpreading()
        inst:RemoveComponent("burnable")
        inst:RemoveComponent("propagator")
    end
end

local function onburntchanges(inst)
    inst:RemoveComponent("growable")
    inst:RemoveTag("shelter")
    inst:RemoveTag("cattoyairborne")
    inst:RemoveTag("monster")
    inst.monster = false

    if inst.monster_start_task ~= nil then
        inst.monster_start_task:Cancel()
        inst.monster_start_task = nil
    end
    if inst.monster_stop_task ~= nil then
        inst.monster_stop_task:Cancel()
        inst.monster_stop_task = nil
    end

    inst.components.lootdropper:SetLoot({})
    if GetBuild(inst).drop_acorns then
        inst.components.lootdropper:AddChanceLoot("acorn", .1)
    end

    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnWorkCallback(nil)
        inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
    end

    if inst.leaveschangetask ~= nil then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end

    inst.MiniMapEntity:SetIcon("tree_leaf_burnt.png")

    inst.AnimState:PlayAnimation(inst.anims.burnt, true)
    inst:DoTaskInTime(3 * FRAMES, _onburntchanges2)
end

local function _OnBurnt2(inst)
    if inst.monster then
        inst.monster = false
        inst:RemoveComponent("meanvertreeupdater")
        inst:RemoveComponent("combat")
        inst.sg:GoToState("empty")
        inst.AnimState:SetBank("tree_leaf")
        inst:DoTaskInTime(FRAMES, onburntchanges)
    else
        onburntchanges(inst)
    end
end

local function OnBurnt(inst, immediate)
    inst:AddTag("burnt")
    if immediate then
        if inst.monster then
            inst.monster = false
            inst:RemoveComponent("meanvertreeupdater")
            inst:RemoveComponent("combat")
            inst.sg:GoToState("empty")
            inst.AnimState:SetBank("tree_leaf")
            inst:DoTaskInTime(FRAMES, onburntchanges)
        else
            onburntchanges(inst)
        end
    else
        inst:DoTaskInTime(.5, _OnBurnt2)
    end

    if inst.components.timer ~= nil and not inst.components.timer:TimerExists("decay") then
        inst.components.timer:StartTimer("decay", GetRandomWithVariance(TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME, TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME * .5))
    end

    inst.AnimState:SetRayTestOnBB(true)
end

local function OnAcornTask(inst)
    inst.acorntask = nil
    inst.components.lootdropper:DropLoot(math.random() < .5 and inst:GetPosition() + TheCamera:GetRightVec() or inst:GetPosition() - TheCamera:GetRightVec())
end

local function tree_burnt(inst)
    OnBurnt(inst)
    inst.acorntask = inst:DoTaskInTime(10, OnAcornTask)
    if inst.leaveschangetask ~= nil then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end
end

local function handler_growfromseed(inst)
    inst.components.growable:SetStage(1)

    if TheWorld.state.isautumn then
        inst.build = ({ "red", "orange", "yellow" })[math.random(3)]
        inst.AnimState:SetMultColour(1, 1, 1, 1)
        inst.leaf_state = "colorful"
        inst.target_leaf_state = "colorful"
    elseif TheWorld.state.iswinter then
        inst.build = "barren"
        inst.leaf_state = "barren"
        inst.target_leaf_state = "barren"
    else
        inst.build = "normal"
        inst.leaf_state = "normal"
        inst.target_leaf_state = "normal"
    end

    --print(inst, "growfromseed, ", inst.target_leaf_state)

    if GetBuild(inst).leavesbuild ~= nil then
        inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
    else
        inst.AnimState:ClearOverrideSymbol("swap_leaves")
    end
    inst.AnimState:PlayAnimation("grow_seed_to_short")
    if inst.leaf_state == "colorful" then
        SpawnLeafFX(inst, 5 * FRAMES)
    end
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    inst.anims = short_anims

    PushSway(inst)
end

local function inspect_tree(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst:HasTag("stump") and "CHOPPED")
        or (inst.monster and "POISON")
        or nil
end

local function onignite(inst)
    if inst.monster and not inst:HasTag("stump") then
        inst.sg:GoToState("burning_pre")
    end
    if inst.components.meanvertreeupdater ~= nil then
        inst.components.meanvertreeupdater:SpawnIgniteWave()
    end
end

local function onextinguish(inst)
    if inst.monster and not inst:HasTag("stump") then
        inst.sg:GoToState("gnash_idle")
    end
end

local function OnEntitySleep(inst)
    if inst._wasonfire or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        if inst:HasTag("stump") then
            DefaultBurntFn(inst)
            return
        end
        inst._wasonfire = true
        inst:RemoveComponent("growable")
        inst:RemoveEventCallback("animover", ChangeSizeFn)
    end
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("inspectable")
end

local function OnEntityWake(inst)
    if not (inst._wasonfire or
            (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or
            inst:HasTag("burnt")) then
        if inst:HasTag("stump") then
            inst:RemoveComponent("burnable")
            MakeSmallBurnable(inst)
            inst:RemoveComponent("propagator")
            MakeSmallPropagator(inst)
        else
            if inst.components.burnable == nil then
                MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
                inst.components.burnable:SetFXLevel(5)
                inst.components.burnable:SetOnBurntFn(tree_burnt)
                inst.components.burnable.extinguishimmediately = false
                inst.components.burnable:SetOnIgniteFn(onignite)
                inst.components.burnable:SetOnExtinguishFn(onextinguish)
            end

            if inst.components.propagator == nil then
                MakeMediumPropagator(inst)
            end
        end
    end

    if (inst._wasonfire or
        (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())) and
        not inst:HasTag("burnt") then
        inst.sg:GoToState("empty")
        inst.AnimState:ClearOverrideSymbol("eye")
        inst.AnimState:ClearOverrideSymbol("mouth")
        if not inst:HasTag("stump") then
            inst.AnimState:ClearOverrideSymbol("legs")
            inst.AnimState:ClearOverrideSymbol("legs_mouseover")
        end
        inst.AnimState:SetBank("tree_leaf")
        OnBurnt(inst, true)
    end

    if inst.components.inspectable == nil then
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree
    end

    inst._wasonfire = nil
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end

    if inst:HasTag("stump") then
        data.stump = true
    end

    if inst.build ~= "normal" then
        data.build = inst.build
    end

    data.target_leaf_state = inst.target_leaf_state
    data.leaf_state = inst.leaf_state
    if inst.leaveschangetask ~= nil and inst.targetleaveschangetime ~= nil then
        data.leaveschangetime = inst.targetleaveschangetime - GetTime()
    end
end

local function onload(inst, data)
    if data ~= nil then
        inst.build = data.build ~= nil and builds[data.build] ~= nil and data.build or "normal"

        inst.target_leaf_state = data.target_leaf_state
        inst.leaf_state = data.leaf_state

        inst.anims =
            (inst.components.growable == nil and tall_anims) or
            (inst.components.growable.stage == 1 and short_anims) or
            (inst.components.growable.stage == 2 and normal_anims) or
            (inst.monster and monster_anims) or
            tall_anims

        if data.stump then
            inst.AnimState:PlayAnimation(inst.anims.stump)

            make_stump(inst)
            if data.burnt or inst:HasTag("burnt") then
                DefaultBurntFn(inst)
            end
        elseif data.burnt then
            inst._wasonfire = true--OnEntityWake will handle it actually doing burnt logic
        end
    end

    if not inst:IsValid() then
        return
    end

    if data ~= nil and data.leaveschangetime ~= nil then
        inst.leaveschangetask = inst:DoTaskInTime(data.leaveschangetime, OnChangeLeaves)
    end

    if data == nil or not (data.burnt or data.stump) then
        if inst.build ~= "normal" or inst.leaf_state ~= inst.target_leaf_state then
            OnChangeLeaves(inst)
        else
            if inst.build == "barren" then
                inst:RemoveTag("shelter")
                inst.AnimState:ClearOverrideSymbol("mouseover")
            else
                inst.AnimState:OverrideSymbol("mouseover", "tree_leaf_trunk_build", "toggle_mouseover")
            end
            Sway(inst)
        end
    end
end

local function OnSeasonChanged(inst, season)
    if not (inst.monster or inst:HasTag("stump") or inst:HasTag("burnt")) then
        if season == SEASONS.AUTUMN then
            if inst.leaf_state ~= "colorful" then
                inst.target_leaf_state = "colorful"
                if inst.leaveschangetask ~= nil then
                    inst.leaveschangetask:Cancel()
                end
                OnChangeLeaves(inst)
            end
        elseif season == SEASONS.WINTER then
            if inst.leaf_state ~= "barren" then
                inst.target_leaf_state = "barren"
                if inst.leaveschangetask ~= nil then
                    inst.leaveschangetask:Cancel()
                end
                OnChangeLeaves(inst)
            end
        elseif inst.leaf_state ~= "normal" then
            inst.target_leaf_state = "normal"
            if inst.leaveschangetask ~= nil then
                inst.leaveschangetask:Cancel()
            end
            OnChangeLeaves(inst)
        end
    end
end

local function ChangeToSeason(inst, targetSeason)
    inst.target_leaf_state =
        (targetSeason == SEASONS.AUTUMN and "colorful") or
        (targetSeason == SEASONS.WINTER and "barren") or
        "normal"

    if inst.leaveschangetask ~= nil then
        inst.leaveschangetask:Cancel()
    end
    if inst.target_leaf_state ~= inst.leaf_state then
        local time = math.random(TUNING.MIN_LEAF_CHANGE_TIME, TUNING.MAX_LEAF_CHANGE_TIME)
        inst.targetleaveschangetime = GetTime() + time
        inst.leaveschangetask = inst:DoTaskInTime(time, OnChangeLeaves)
    else
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
    end
end

local function OnCyclesChanged(inst, cycles)
    if inst.leaveschangetask ~= nil or TheWorld.state.remainingdaysinseason > 3 then
        return
    end
    local nextSeason =
    {
        [SEASONS.AUTUMN] = SEASONS.WINTER,
        [SEASONS.WINTER] = SEASONS.SPRING,
        [SEASONS.SPRING] = SEASONS.SUMMER,
        [SEASONS.SUMMER] = SEASONS.AUTUMN,
    }
    local currentSeason = TheWorld.state.season
    local targetSeason = nextSeason[currentSeason]
    if targetSeason ~= nil then
        local seasonlengths =
        {
            [SEASONS.AUTUMN] = "autumnlength",
            [SEASONS.WINTER] = "winterlength",
            [SEASONS.SPRING] = "springlength",
            [SEASONS.SUMMER] = "summerlength"
        }
        if TheWorld.state[seasonlengths[targetSeason]] > 0 then
            ChangeToSeason(inst, targetSeason)
        else
            targetSeason = nextSeason[targetSeason]
            while targetSeason ~= currentSeason and TheWorld.state[seasonlengths[targetSeason]] <= 0 do
                targetSeason = nextSeason[targetSeason]
            end
            if targetSeason ~= currentSeason and TheWorld.state[seasonlengths[targetSeason]] > 0 then
                ChangeToSeason(inst, targetSeason)
            end
        end
    end
end

-- Set up leaf state at start of game
local function OnInitSeason(inst)
    if not (inst.monster or inst:HasTag("stump") or inst:HasTag("burnt")) then
        inst.target_leaf_state =
            (TheWorld.state.isautumn and "colorful") or
            (TheWorld.state.iswinter and "barren") or
            "normal" --SPRING AND SUMMER

        OnChangeLeaves(inst)
    end
end

local function onsway(inst, data)
    --NOTE: monster and monsterpost are booleans (hence no "or nil")
    Sway(inst, data ~= nil and data.monster, data ~= nil and data.monsterpost)
end

local function OnHaunt(inst, haunter)
    local isstump = inst:HasTag("stump")
    if not isstump and
        inst.components.workable ~= nil and
        math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        inst.components.workable:WorkedBy(haunter, 1)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        return true
    elseif inst:HasTag("burnt") then
        return false
    --#HAUNTFIX
    --elseif inst.components.burnable ~= nil and
        --not inst.components.burnable:IsBurning() and
        --math.random() <= TUNING.HAUNT_CHANCE_VERYRARE then
        --inst.components.burnable:Ignite()
        --inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
        --inst.components.hauntable.cooldown_on_successful_haunt = false
        --return true
    end
    return false
end

local function makefn(build, stage, data)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .25)

        inst.MiniMapEntity:SetIcon("tree_leaf.png")
        inst.MiniMapEntity:SetPriority(-1)

        inst:AddTag("tree")
        inst:AddTag("birchnut")
        inst:AddTag("cattoyairborne")
        inst:AddTag("meanvertree")
        inst:AddTag("shelter")

        inst.build = build
        inst.AnimState:SetBank("tree_leaf")
        inst.AnimState:SetBuild("tree_leaf_trunk_build")

        inst.AnimState:Hide("mouseover")

        if GetBuild(inst).leavesbuild ~= nil then
            inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
        end

        inst:SetPrefabName(GetBuild(inst).prefab_name)

        MakeSnowCoveredPristine(inst)

        --Sneak these into pristine state for optimization
        inst:AddTag("__combat")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        --Remove these tags so that they can be added properly when replicating components below
        inst:RemoveTag("__combat")

        inst:PrereplicateComponent("combat")

        -- inst:SetStateGraph("SGdeciduoustree")
        inst.sg:GoToState("empty")

        inst.color = .5 + math.random() * .5
        inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)

        MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
        inst.components.burnable:SetFXLevel(5)
        inst.components.burnable:SetOnBurntFn(tree_burnt)
        inst.components.burnable.extinguishimmediately = false
        inst.components.burnable:SetOnIgniteFn(onignite)
        inst.components.burnable:SetOnExtinguishFn(onextinguish)

        MakeMediumPropagator(inst)

        inst:AddComponent("plantregrowth")
        inst.components.plantregrowth:SetRegrowthRate(TUNING.DECIDUOUS_REGROWTH.OFFSPRING_TIME)
        inst.components.plantregrowth:SetProduct("acorn_sapling")
        inst.components.plantregrowth:SetSearchTag("meanvertree")

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        inst.components.workable:SetOnWorkCallback(chop_tree)
        inst.components.workable:SetOnFinishCallback(chop_down_tree)

        inst:AddComponent("lootdropper")

        inst:ListenForEvent("sway", onsway)

        inst.lastleaffxtime = 0
        inst.leaffxinterval = math.random(TUNING.MIN_SWAY_FX_FREQUENCY, TUNING.MAX_SWAY_FX_FREQUENCY)
        inst.SpawnLeafFX = SpawnLeafFX
        inst:ListenForEvent("deciduousleaffx", function(world)
            if inst.entity:IsAwake() then
                if inst.leaf_state == "colorful" and GetTime() - inst.lastleaffxtime > inst.leaffxinterval then
                    SpawnLeafFX(inst, math.random() * 2)
                    inst.leaffxinterval = math.random(TUNING.MIN_SWAY_FX_FREQUENCY, TUNING.MAX_SWAY_FX_FREQUENCY)
                    inst.lastleaffxtime = GetTime()
                end
            end
        end, TheWorld)

        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(stage == 0 and math.random(1, 3) or stage)
        inst.components.growable.loopstages = true
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()

        inst.growfromseed = handler_growfromseed

        inst:AddComponent("hauntable")
        -- Haunt effects more or less the same as evergreens
        inst.components.hauntable:SetOnHauntFn(OnHaunt)

        inst:WatchWorldState("cycles", OnCyclesChanged)
        inst:WatchWorldState("season", OnSeasonChanged)

        inst.leaf_state = "normal"

        inst.OnSave = onsave
        inst.OnLoad = onload

        MakeSnowCovered(inst)

        if data == "stump" then
            RemovePhysicsColliders(inst)
            inst:AddTag("stump")
            inst:RemoveTag("shelter")

            inst:RemoveComponent("burnable")
            MakeSmallBurnable(inst)
            inst:RemoveComponent("workable")
            inst:RemoveComponent("propagator")
            MakeSmallPropagator(inst)
            inst:RemoveComponent("growable")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetOnFinishCallback(dig_up_stump)
            inst.components.workable:SetWorkLeft(1)
            inst.AnimState:PlayAnimation(inst.anims.stump)
            inst.MiniMapEntity:SetIcon("tree_leaf_stump.png")
        else
            --When POPULATING, season won't be valid yet at this point,
            --but we want this immediate for all later spawns.
            OnInitSeason(inst)
            inst.AnimState:SetTime(math.random() * 2)
            if data == "burnt" then
                OnBurnt(inst, true)
            elseif POPULATING then
                --Redo this after season is valid
                inst:DoTaskInTime(0, OnInitSeason)
            end
        end

        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake
        inst._wasonfire = nil

        return inst
    end
end

local function tree(name, build, stage, data)
    return Prefab(name, makefn(build, stage, data), assets, prefabs)
end

return tree("meanvertree", "normal", 0),
        tree("meanvertree_normal", "normal", 2),
        tree("meanvertree_tall", "normal", 3),
        tree("meanvertree_short", "normal", 1),
        tree("meanvertree_burnt", "normal", 0, "burnt"),
        tree("meanvertree_stump", "normal", 0, "stump")
