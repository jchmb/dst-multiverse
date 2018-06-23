--[[
    Prefabs for 3 different mushtrees
--]]

local TREESTATES =
{
    BLOOMING = "bloom",
    NORMAL = "normal",
}

-- local function tree_burnt(inst)
--     inst.components.lootdropper:SpawnLootPrefab("ash")
--     if math.random() < 0.5 then
--         inst.components.lootdropper:SpawnLootPrefab("charcoal")
--     end
--     SpawnPrefab(inst.prefab..(inst.treestate == TREESTATES.BLOOMING and "_bloom_burntfx" or "_burntfx")).Transform:SetPosition(inst.Transform:GetWorldPosition())
--     inst:Remove()
-- end
--
-- local function stump_burnt(inst)
--     SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
--     inst:Remove()
-- end

local function dig_up_stump(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function inspect_tree(inst)
    return (inst:HasTag("stump") and "CHOPPED")
        or (inst.treestate == TREESTATES.BLOOMING and "BLOOM")
        or nil
end

local data =
{
    metal =
    { --Blue
        bank = "mushroom_tree",
        build = "mushroom_tree_metal",
        bloom_build = "mushroom_tree_tall_bloom",
        spore = "spore_tall",
        icon = "mushroom_tree.png",
        loot = { "log", "log", "ironnugget" },
        work = TUNING.MUSHTREE_CHOPS_TALL,
        lightradius = 2,
        lightcolour = { 209/255, 212/255, 216/255 },
        webbable = true,
    },
}

local function onsave(inst, data)
    -- data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
    data.stump = inst:HasTag("stump") or nil
    data.treestate = inst.treestate
end

local function swapbuild(inst, treestate, build)
    inst._changetask = nil
    if not inst:HasTag("stump") then
        inst.AnimState:SetBuild(build)
        inst.treestate = treestate
    end
end

local function maketree(name, data, state)
    local function normal_tree(inst, instant)
        swapbuild(inst, TREESTATES.NORMAL, data.build)
    end

    local function makestump(inst)
        if inst:HasTag("stump") then
            return
        end

        RemovePhysicsColliders(inst)
        inst:AddTag("stump")
        inst:RemoveTag("shelter")
        inst:RemoveComponent("propagator")
        inst:RemoveComponent("burnable")

        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnWorkCallback(nil)
        inst.components.workable:SetOnFinishCallback(dig_up_stump)
        inst.components.workable:SetWorkLeft(1)
        inst.AnimState:PlayAnimation("idle_stump")

        inst.MiniMapEntity:SetIcon("mushroom_tree_stump.png")

        inst.Light:Enable(false)
    end

    local function workcallback(inst, worker, workleft)
        if not (worker ~= nil and worker:HasTag("playerghost")) then
            inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_mushroom")
        end
        if workleft <= 0 then
            inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
            makestump(inst)

            inst.AnimState:PlayAnimation("fall")

            inst.components.lootdropper:DropLoot(inst:GetPosition())
            inst.AnimState:PushAnimation("idle_stump")
        else
            inst.AnimState:PlayAnimation("chop")
            inst.AnimState:PushAnimation("idle_loop", true)
        end
    end

    local function onload(inst, loaddata)
        if loaddata ~= nil then
            if loaddata.stump then
                makestump(inst)
            elseif loaddata.treestate == TREESTATES.NORMAL then
                normal_tree(inst, true)
                if TheWorld.state.season == data.season then
                    bloom_tree(inst, false)
                end
            end
        end
    end

    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .25)

        inst.AnimState:SetBuild(data.build)
        inst.AnimState:SetBank(data.bank)
        inst.AnimState:PlayAnimation("idle_loop", true)

        inst.MiniMapEntity:SetIcon(data.icon)

        inst.Light:SetFalloff(.5)
        inst.Light:SetIntensity(.8)
        inst.Light:SetRadius(data.lightradius)
        inst.Light:SetColour(unpack(data.lightcolour))

        inst:AddTag("shelter")
        inst:AddTag("mushtree")
        inst:AddTag("cavedweller")
        inst:AddTag("tree")

        if data.webbable then
            inst:AddTag("webbable")
        end

        inst:SetPrefabName(name)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        local color = .5 + math.random() * .5
        inst.AnimState:SetMultColour(color, color, color, 1)
        inst.AnimState:SetTime(math.random() * 2)

        -- MakeMediumPropagator(inst)
        -- MakeLargeBurnable(inst)
        -- inst.components.burnable:SetFXLevel(5)
        -- inst.components.burnable:SetOnBurntFn(tree_burnt)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(data.loot)

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE))
        inst.components.workable:SetOnWorkCallback(workcallback)

        -- inst:AddComponent("periodicspawner")
        -- inst.components.periodicspawner:SetPrefab(data.spore)
        -- inst.components.periodicspawner:SetOnSpawnFn(onspawnfn)
        -- inst.components.periodicspawner:SetDensityInRange(TUNING.MUSHSPORE_MAX_DENSITY_RAD, TUNING.MUSHSPORE_MAX_DENSITY)
        -- StopSpores(inst)

        -- inst:AddComponent("growable")
        -- inst.components.growable.stages = growth_stages
        -- inst.components.growable:SetStage(math.random(3))
        -- inst.components.growable.loopstages = true
        -- inst.components.growable.growonly = true
        -- inst.components.growable:StartGrowing()

        -- inst:AddComponent("plantregrowth")
        -- inst.components.plantregrowth:SetRegrowthRate(TUNING.MUSHTREE_REGROWTH.OFFSPRING_TIME)
        -- inst.components.plantregrowth:SetProduct(name)
        -- inst.components.plantregrowth:SetSearchTag("mushtree")

        -- inst:AddComponent("timer")

        -- MakeHauntableIgnite(inst)
        -- AddHauntableCustomReaction(inst, CustomOnHaunt)

        inst.treestate = TREESTATES.NORMAL

        inst.OnSave = onsave
        inst.OnLoad = onload

        if state == "stump" then
            makestump(inst)
        else
            normal_tree(inst, true)
        end

        return inst
    end
end

local treeprefabs = {}
function treeset(name, data, anim, build, bloombuild)
    local animasset = Asset("ANIM", anim)
    local buildasset = Asset("ANIM", build)
    local bloombuildasset = Asset("ANIM", bloombuild)
    local assets =
    {
        animasset,
        buildasset,
        bloombuildasset,
        Asset("MINIMAP_IMAGE", data.icon),
        Asset("MINIMAP_IMAGE", "mushroom_tree_stump"),
    }

    local prefabs =
    {
        "ironnugget",
        "log",
        "blue_cap",
        "green_cap",
        "red_cap",
        "charcoal",
        "ash",
        -- data.spore,
        name.."_stump",
        name.."_burntfx",
        name.."_bloom_burntfx",
    }

    table.insert(treeprefabs, Prefab(name, maketree(name, data), assets, prefabs))
    table.insert(treeprefabs, Prefab(name.."_stump", maketree(name, data, "stump"), assets, prefabs))
    -- table.insert(treeprefabs, Prefab(name.."_burntfx", makeburntfx(name, data, false), { buildasset }))
    -- table.insert(treeprefabs, Prefab(name.."_bloom_burntfx", makeburntfx(name, data, true), { bloombuildasset }))
end

treeset("mushtree_metal", data.metal, "anim/mushroom_tree_tall.zip", "anim/mushroom_tree_metal.zip", "anim/mushroom_tree_tall_bloom.zip")

return unpack(treeprefabs)
