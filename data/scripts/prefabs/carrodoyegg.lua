local assets=
{
	Asset("ANIM", "anim/doydoy_nest.zip"),
	Asset("ANIM", "anim/carrodoy_nest.zip"),
}

local prefabs =
{
	-- "doydoyegg_cracked",
	-- "doydoyegg_cooked",
	-- "spoiled_food",
}

local function commonfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBuild("carrodoy_nest")
	inst.AnimState:SetBank("doydoy_nest")
	inst.AnimState:PlayAnimation("idle_egg")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "MEAT"

	inst:AddComponent("perishable")
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddTag("cattoy")
	inst:AddComponent("tradable")

	return inst
end


local function defaultfn()
	local inst = commonfn()

	inst:AddTag("doydoyegg")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.imagename = "doydoyegg"

	inst.components.edible.healthvalue = TUNING.HEALING_SMALL
	inst.components.edible.hungervalue = TUNING.CALORIES_MED

	inst:AddComponent("cookable")
	inst.components.cookable.product = "doydoyegg_cooked"

	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()

	inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_MEDIUM

	return inst
end

local function cookedfn()
	local inst = commonfn()

	inst:AddComponent("stackable")

	inst.AnimState:PlayAnimation("cooked")
	inst.components.edible.foodstate = "COOKED"
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = TUNING.CALORIES_LARGE

	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()

	return inst
end

-- doydoyegg_cracked is really just here so old saves don't blow up
return Prefab( "carrodoyegg", defaultfn, assets, prefabs),
		Prefab( "carrodoyegg_cracked", defaultfn, assets, prefabs),
		Prefab( "carrodoyegg_cooked", cookedfn, assets, prefabs)
