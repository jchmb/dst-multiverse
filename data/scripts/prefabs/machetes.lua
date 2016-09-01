local assets=
{
	Asset("ANIM", "anim/machete.zip"),
	Asset("ANIM", "anim/machete_obsidian.zip"),
	Asset("ANIM", "anim/goldenmachete.zip"),
	Asset("ANIM", "anim/swap_machete.zip"),
	Asset("ANIM", "anim/swap_machete_obsidian.zip"),
	Asset("ANIM", "anim/swap_goldenmachete.zip"),
}

local function onfinished(inst)
	inst:Remove()
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_machete", "swap_machete")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	-- MakeInventoryFloatable(inst, "idle_water", "idle")

	anim:SetBank("machete")
	anim:SetBuild("machete")
	anim:PlayAnimation("idle")

	inst:AddTag("sharp")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.MACHETE_DAMAGE)

	-----
	inst:AddComponent("tool")
	-- inst.components.tool:SetAction(ACTIONS.HACK)
	-------
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.MACHETE_USES)
	inst.components.finiteuses:SetUses(TUNING.MACHETE_USES)
	inst.components.finiteuses:SetOnFinished( onfinished)
	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1)
	-------
	inst:AddComponent("equippable")

	inst:AddComponent("inspectable")



	inst.components.equippable:SetOnEquip( onequip )

	inst.components.equippable:SetOnUnequip( onunequip)


	return inst
end

local function normal(Sim)
	local inst = fn()

	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/machete.xml"

	return inst
end

local function onequipgold(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_goldenmachete", "swap_goldenmachete")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function golden(Sim)
	local inst = fn(Sim)
	inst.AnimState:SetBuild("goldenmachete")
	inst.AnimState:SetBank("machete")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goldenmachete.xml"
	
	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1 / TUNING.GOLDENTOOLFACTOR)
	inst.components.weapon.attackwear = 1 / TUNING.GOLDENTOOLFACTOR
	inst.components.equippable:SetOnEquip( onequipgold )

	return inst
end

local function onequipobsidian(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_machete_obsidian", "swap_machete")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function obsidian(Sim)
	local inst = fn(Sim)

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("inventoryitem")

	inst.AnimState:SetBuild("machete_obsidian")
	inst.AnimState:SetBank("machete_obsidian")

	-- inst.components.tool:SetAction(ACTIONS.HACK, TUNING.OBSIDIANTOOL_WORK)

	inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1 / TUNING.OBSIDIANTOOLFACTOR)
	inst.components.weapon.attackwear = 1 / TUNING.OBSIDIANTOOLFACTOR
	inst.components.equippable:SetOnEquip(onequipobsidian)

	-- TODO: 
	-- MakeObsidianTool(inst, "machete")

	return inst
end

return Prefab( "machete", normal, assets),
	   Prefab( "goldenmachete", golden, assets),
	   Prefab( "obsidianmachete", obsidian, assets)
