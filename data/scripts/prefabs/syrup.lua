local assets =
{
    Asset("ANIM", "anim/quagmire_syrup.zip"),
}

local prefabs =
{
    -- "quagmire_burnt_ingredients",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("quagmire_syrup")
    inst.AnimState:SetBank("quagmire_syrup")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("quagmire_stewable")
    inst:AddTag("sweetener")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_syrup"

    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    -- event_server_data("quagmire", "prefabs/quagmire_syrup").master_postinit(inst)

    return inst
end

return Prefab("syrup", fn, assets, prefabs)
