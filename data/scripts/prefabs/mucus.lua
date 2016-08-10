local assets =
{
    Asset("ANIM", "anim/phlegm.zip"),
    Asset("ANIM", "anim/mucus.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("phlegm")
    inst.AnimState:SetBuild("mucus")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mucus.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 9
    inst.components.edible.sanityvalue = -6
    inst.components.edible.foodtype = FOODTYPE.GENERIC

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("mucus", fn, assets)
