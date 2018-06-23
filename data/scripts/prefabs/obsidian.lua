local assets=
{
	Asset("ANIM", "anim/obsidian.zip"),
}

--local function heatfn(inst, observer)
--    return 0.5 * inst.components.stackable:StackSize()
--end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetRayTestOnBB(true);
	inst.AnimState:SetBank("obsidian")
	inst.AnimState:SetBuild("obsidian")
	inst.AnimState:PlayAnimation("idle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "ELEMENTAL"

	--inst:AddComponent("tradable")


	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/obsidian.xml"

	--inst:AddComponent("heater")
	--inst.components.heater.heatfn = heatfn
	--inst.components.heater.carriedheatfn = heatfn

	inst:AddComponent("bait")
	inst:AddTag("molebait")

	return inst
end

return Prefab( "obsidian", fn, assets)
