local rock_slimey_assets =
{
    Asset("ANIM", "anim/rock_slimey.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local rock_charcoal_assets =
{
    Asset("ANIM", "anim/rock_charcoal.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local rock_iron_assets =
{
    Asset("ANIM", "anim/rock2.zip"),
    Asset("ANIM", "anim/rock_iron.zip"),
    Asset("MINIMAP_IMAGE", "minimap_rock_iron.tex"),
}

local rock_obsidian_assets =
{
    Asset("ANIM", "anim/rock_obsidian.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local rock_magma_assets =
{
    Asset("ANIM", "anim/rock_magma.zip"),
    Asset("MINIMAP_IMAGE", "minimap_rock_magma.tex"),
}

local rock_magma_gold_assets =
{
    Asset("ANIM", "anim/rock_magma_gold.zip"),
    Asset("MINIMAP_IMAGE", "minimap_rock_magma.tex"),
}

local petrified_tree_metal_assets =
{
    Asset("ANIM", "anim/petrified_tree.zip"),
    Asset("ANIM", "anim/petrified_tree_metal.zip"),
    Asset("MINIMAP_IMAGE", "petrified_tree.png"),
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
    "phlegm",
    "mucus",
    "charcoal",
    "wetgoop",
}

SetSharedLootTable('rock_slimey',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'mucus',  1.00},
    {'mucus',  1.00},
    {'phlegm',  0.25},
    {'flint',  0.50},
    {'wetgoop', 0.50},
})

SetSharedLootTable('rock_charcoal',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'charcoal',  1.00},
    {'flint',  1.00},
    {'charcoal',  0.25},
    {'flint',  0.60},
})

SetSharedLootTable('rock_iron',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'flint',  1.00},
    {'flint',  0.60},
    {'ironnugget', 1.00},
    {'ironnugget', 0.50},
    {'ironnugget', 0.50},
})

SetSharedLootTable('petrified_tree_metal',
{
    {'log', 1.00},
    {'log', 0.75},
    {'log', 0.50},
    {'flint',  0.50},
    {'ironnugget', 1.00},
    {'ironnugget', 0.50},
})

SetSharedLootTable('rock_obsidian',
{
    {'obsidian', 1.00},
    {'obsidian', 1.00},
    {'obsidian', 0.50},
    {'obsidian', 0.25},
    {'obsidian', 0.25},
})

SetSharedLootTable('rock_magma',
{
    {'rocks', 1.00},
    {'rocks', 1.00},
    {'rocks', 1.00},
    {'flint', 0.75},
    {'nitre', 0.75},
    {'redgem', 0.125},
    {'bluegem', 0.125},
})

SetSharedLootTable('rock_magma_gold',
{
    {'rocks', 1.00},
    {'rocks', 1.00},
    {'goldnugget', 1.00},
    {'flint', 0.75},
    {'nitre', 0.75},
    {'redgem', 0.125},
    {'bluegem', 0.125},
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
    local inst = baserock_fn("rock_slimey", "rock_slimey", "full", "minimap_rock_slimey.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock_slimey')

    return inst
end

local function rock_charcoal_fn()
    local inst = baserock_fn("rock_charcoal", "rock_charcoal", "full")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock_charcoal')

    return inst
end

local function rock_iron_fn()
    local inst = baserock_fn("rock2", "rock_iron", "full", "minimap_rock_iron.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock_iron')

    return inst
end

local function rock_obsidian_fn()
    local inst = baserock_fn("rock_obsidian", "rock_obsidian", "full")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock_obsidian')

    return inst
end

local function rock_magma_fn()
    local inst = baserock_fn("rock_magma", "rock_magma", "full", "minimap_rock_magma.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock_magma')

    return inst
end

local function rock_magma_gold_fn()
    local inst = baserock_fn("rock_magma_gold", "rock_magma_gold", "full", "minimap_rock_magma.tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('rock_magma_gold')

    return inst
end

local function petrified_tree_metal_fn()
    local inst = baserock_fn("petrified_tree", "petrified_tree_metal", "full", "petrified_tree.png")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('petrified_tree_metal')

    return inst
end

return Prefab("rock_slimey", rock_slimey_fn, rock_slimey_assets, prefabs),
    Prefab("rock_charcoal", rock_charcoal_fn, rock_charcoal_assets, prefabs),
    Prefab("rock_obsidian", rock_obsidian_fn, rock_obsidian_assets, prefabs),
    Prefab("rock_iron", rock_iron_fn, rock_iron_assets, prefabs),
    Prefab("rock_magma", rock_magma_fn, rock_magma_assets, prefabs),
    Prefab("rock_magma_gold", rock_magma_gold_fn, rock_magma_gold_assets, prefabs),
    Prefab("petrified_tree_metal", petrified_tree_metal_fn, petrified_tree_metal_assets, prefabs)
