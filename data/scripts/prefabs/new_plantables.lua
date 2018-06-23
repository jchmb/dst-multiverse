require "prefabutil"

local function make_plantable(data)
    local workable_type = data.workable or "pickable"

    local animfile = data.animfile or data.name

    local assets =
    {
        Asset("ANIM", "anim/"..animfile..".zip"),
        Asset("ANIM", "anim/berrybush.zip"),
        Asset("ANIM", "anim/berrybush2.zip"),
        Asset("ATLAS", "images/inventoryimages/dug_" .. data.name..".xml"),
    }

    if data.build ~= nil then
        table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))
    end

    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab(data.name)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            -- if workable_type == "pickable" then
                tree.components.pickable:OnTransplant()
            -- elseif workable_type == "hackable" then
            --     tree.components.hackable:OnTransplant()
            -- end
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                --V2C: WHY?!! because many of the plantables don't
                --     have SoundEmitter, and we don't want to add
                --     one just for this sound!
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        --inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(data.bank or data.name)
        inst.AnimState:SetBuild(data.build or data.name)
        inst.AnimState:PlayAnimation("dropped")

        MakeDragonflyBait(inst, 3)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = data.inspectoverride or "dug_"..data.name
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/dug_"..data.name..".xml"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end

        ---------------------
        return inst
    end

    return Prefab("dug_"..data.name, fn, assets)
end

local plantables =
{
    {
        name = "coffeebush",
        anim = "idle_dead"
    },
    {
        name = "bittersweetbush",
        anim = "dead",
        bank = "berrybush",
    },
    {
        name = "mintybush",
        anim = "dead",
        bank = "berrybush2",
        build = "berrybush2",
    },
    {
        name="bambootree",
        minspace = 2,
        bank = "bambootree",
        build = "bambootree_build",
        -- workable = "hackable",
        -- testfn=test_nobeach
    },
    {
        name="elephantcactus",
        bank = "cactus_volcano",
        build = "cactus_volcano",
        anim="idle_dead",
        minspace=2,
        -- testfn=test_volcano,
        noburn=true,
        deployatrange=true,
        animfile = "cactus_volcano",
    },
}

local prefabs = {}
for i, v in ipairs(plantables) do
    table.insert(prefabs, make_plantable(v))
    table.insert(prefabs, MakePlacer("dug_"..v.name.."_placer", v.bank or v.name, v.build or v.name, v.anim or "idle"))
end

return unpack(prefabs)
