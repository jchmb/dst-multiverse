local assets =
{
    Asset("ANIM", "anim/quagmire_sap.zip"),
}

local prefabs =
{
    -- "quagmire_burnt_ingredients",
    -- "quagmire_syrup",
}

local function MakeSap(name, fresh)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("sweetener")

        inst.AnimState:SetBuild("quagmire_sap")
        inst.AnimState:SetBank("quagmire_sap")
        inst.AnimState:PlayAnimation(fresh and "idle" or "idle_spoiled")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -- event_server_data("quagmire", "prefabs/quagmire_sap").master_postinit(inst, fresh)

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = TUNING.HEALING_SMALL
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")

        inst:AddComponent("inspectable")

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "sap_spoiled"

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. name .. ".xml"

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    return Prefab(name, fn, assets, fresh and prefabs or nil)
end

return MakeSap("sap", true),
    MakeSap("sap_spoiled", false)
