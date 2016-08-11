local assets=
{
	Asset("ANIM", "anim/shark_gills.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("shark_gills")
	inst.AnimState:SetBuild("shark_gills")
	inst.AnimState:PlayAnimation("idle")
	MakeInventoryPhysics(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/shark_gills.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	return inst
end

return Prefab( "shark_gills", fn, assets) 
