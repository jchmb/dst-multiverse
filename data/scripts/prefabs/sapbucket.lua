local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_sapbucket")
    inst.AnimState:SetBuild("quagmire_sapbucket")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 1

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sapbucket.xml"

    inst:AddComponent("tapper")

    -- event_server_data("quagmire", "prefabs/quagmire_sapbucket").master_postinit(inst)

    return inst
end

return Prefab("sapbucket", fn, assets, prefabs)
