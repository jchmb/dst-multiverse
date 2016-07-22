local rock1_assets =
{
    Asset("ANIM", "anim/rock.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local rock2_assets =
{
    Asset("ANIM", "anim/rock2.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local rock_flintless_assets =
{
    Asset("ANIM", "anim/rock_flintless.zip"),
}

local rock_moon_assets =
{
    Asset("ANIM", "anim/rock7.zip"),
}

local rock_petrified_tree_assets =
{
    Asset("ANIM", "anim/petrified_tree.zip"),
    Asset("ANIM", "anim/petrified_tree_tall.zip"),
    Asset("ANIM", "anim/petrified_tree_short.zip"),
    Asset("ANIM", "anim/petrified_tree_old.zip"),
    Asset("MINIMAP_IMAGE", "petrified_tree"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "flint",
    "goldnugget",
    "moonrocknugget",
    "rock_break_fx",
    "collapse_small",
}

SetSharedLootTable('rock_slimey',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'phlegm',  1.00},
    {'flint',  1.00},
    {'phlegm',  0.25},
    {'flint',  0.60},
})

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.components.lootdropper:DropLoot(pt)

        if inst.showCloudFXwhenRemoved then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end

        inst:Remove()
    else
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.ROCKS_MINE / 3 and "low") or
            (workleft < TUNING.ROCKS_MINE * 2 / 3 and "med") or
            "full"
        )
    end
end

local function onsave(inst, data)
    data.treeSize = inst.treeSize
end

local function onload(inst, data)
    if data ~= nil and data.treeSize ~= nil then
        inst.treeSize = data.treeSize
        --V2C: Note that this will reset workleft as well
        --     Gotta change this if you set workable to savestate
        setPetrifiedTreeSize(inst) 
    end
end
local function baserock_fn(bank, build, anim, icon, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon(icon or "rock.png")

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    if type(anim) == "table" then
        for i, v in ipairs(anim) do
            if i == 1 then
                inst.AnimState:PlayAnimation(v)
            else
                inst.AnimState:PushAnimation(v, false)
            end
        end
    else
        inst.AnimState:PlayAnimation(anim)
    end

    MakeSnowCoveredPristine(inst)

    inst:AddTag("boulder")
    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper") 

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "ROCK"
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

local function rock_slimey_fn()
    local inst = baserock_fn("rock", "rock", "full")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock1')

    return inst
end

return Prefab("rock_slimey", rock_slimey_fn, rock_slimey_assets, prefabs)