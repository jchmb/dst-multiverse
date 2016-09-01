local assets =
{
	Asset("ANIM", "anim/sandhill.zip")
}

local function sandfn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)

	anim:SetBuild( "sandhill" )
	anim:SetBank( "sandhill" )
	anim:PlayAnimation("idle")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	-----------------
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	----------------------
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sand.xml"
	
	return inst
end

return Prefab( "sand", sandfn, assets)