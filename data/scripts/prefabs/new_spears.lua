local basic_assets =
{
	Asset("ANIM", "anim/spear.zip"),
	Asset("ANIM", "anim/swap_spear.zip"),
}
-- local poison_assets =
-- {
-- 	Asset("ANIM", "anim/spear_poison.zip"),
-- 	Asset("ANIM", "anim/swap_spear_poison.zip"),
-- }
local obsidian_assets =
{
	Asset("ANIM", "anim/spear_obsidian.zip"),
	Asset("ANIM", "anim/swap_spear_obsidian.zip"),
}

local needle_assets =
{
	Asset("ANIM", "anim/swap_cactus_spike.zip"),
	Asset("ANIM", "anim/cactus_spike.zip"),
}
-- local pegleg_assets =
-- {
-- 	Asset("ANIM", "anim/swap_peg_leg.zip"),
-- 	Asset("ANIM", "anim/peg_leg.zip"),
-- }

local function onfinished(inst)
	inst:Remove()
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

-- local function poisonattack(inst, attacker, target, projectile)
-- 	if target.components.poisonable then
-- 		target.components.poisonable:Poison()
-- 	end
-- 	if target.components.combat then
-- 		target.components.combat:SuggestTarget(attacker)
-- 	end
-- 	-- this was commented out as the attack with the spear will do an attacked event. The poison itself doesn't need a second one pushed
-- 	--target:PushEvent("attacked", {attacker = attacker, damage = 0, projectile = projectile})
-- end


local function commonfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	-- MakeInventoryFloatable(inst, "idle_water", "idle")

	inst:AddTag("sharp")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)

	inst:AddComponent("tradable")

	-------

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
	inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

	inst.components.finiteuses:SetOnFinished( onfinished )

	inst:AddComponent("inspectable")

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( onequip )
	inst.components.equippable:SetOnUnequip( onunequip )

	return inst
end

local function basicfn()
	local inst = commonfn()

	inst:AddComponent("inventoryitem")

	inst.AnimState:SetBuild("spear")
	inst.AnimState:SetBank("spear")
	inst.AnimState:PlayAnimation("idle")
	inst:AddTag("spear")

	inst.speartype = "spear"

	return inst
end

-- local function onequippoison(inst, owner)
-- 	owner.AnimState:OverrideSymbol("swap_object", "swap_spear_poison", "swap_spear")
-- 	owner.AnimState:Show("ARM_carry")
-- 	owner.AnimState:Hide("ARM_normal")
-- end
--
-- local function poisonfn(Sim)
-- 	local inst = commonfn(Sim)
--
-- 	inst:AddComponent("inventoryitem")
--
-- 	inst.AnimState:SetBuild("spear_poison")
-- 	inst.AnimState:SetBank("spear_poison")
-- 	inst.AnimState:PlayAnimation("idle")
--
-- 	inst.components.weapon:SetOnAttack(poisonattack)
-- 	inst.components.equippable:SetOnEquip(onequippoison)
-- 	inst:AddTag("spear")
--
-- 	inst.speartype = "poison"
--
-- 	return inst
-- end

local function onequipobsidian(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_spear_obsidian", "swap_spear")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function obsidianfn()
	local inst = commonfn()

	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/spear_obsidian.xml"

	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

	inst.entity:AddSoundEmitter()
	inst:AddTag("spear")

	inst.AnimState:SetBuild("spear_obsidian")
	inst.AnimState:SetBank("spear_obsidian")
	inst.AnimState:PlayAnimation("idle")

	inst.components.weapon:SetDamage(TUNING.OBSIDIAN_SPEAR_DAMAGE)
	inst.components.weapon.attackwear = 1 / TUNING.OBSIDIANTOOLFACTOR
	inst.components.equippable:SetOnEquip( onequipobsidian )

	inst.speartype = "obsidian"

	-- MakeObsidianTool(inst, "spear")
	-- inst.components.obsidiantool.maxcharge = TUNING.OBSIDIAN_WEAPON_MAXCHARGES
    -- inst.components.obsidiantool.cooldowntime = TUNING.TOTAL_DAY_TIME / TUNING.OBSIDIAN_WEAPON_MAXCHARGES

	return inst
end

local function onequipneedle(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_cactus_spike", "swap_cactus_spike")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function needlefn(Sim)
	local inst = commonfn(Sim)

	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/needlespear.xml"

	inst.AnimState:SetBuild("cactus_spike")
	inst.AnimState:SetBank("cactus_spike")
	inst.AnimState:PlayAnimation("idle")

	inst.components.weapon:SetDamage(TUNING.NEEDLESPEAR_DAMAGE)
	inst.components.finiteuses:SetMaxUses(TUNING.NEEDLESPEAR_USES)
	inst.components.finiteuses:SetUses(TUNING.NEEDLESPEAR_USES)

	inst.components.inventoryitem.imagename = "needlespear"

	inst.components.equippable:SetOnEquip( onequipneedle )

	return inst
end

-- local function onequippegleg(inst, owner)
-- 	owner.AnimState:OverrideSymbol("swap_object", "swap_peg_leg", "swap_object")
-- 	owner.AnimState:Show("ARM_carry")
-- 	owner.AnimState:Hide("ARM_normal")
-- end

-- local function peglegfn(Sim)
-- 	local inst = commonfn(Sim)
--
-- 	inst:AddTag("pegleg")
--
-- 	inst:AddComponent("inventoryitem")
--
-- 	inst.AnimState:SetBuild("peg_leg")
-- 	inst.AnimState:SetBank("peg_leg")
-- 	inst.AnimState:PlayAnimation("idle")
--
-- 	inst.components.equippable:SetOnEquip(onequippegleg)
--
-- 	inst.components.weapon:SetDamage(TUNING.PEG_LEG_DAMAGE)
-- 	inst.components.finiteuses:SetMaxUses(TUNING.PEG_LEG_USES)
-- 	inst.components.finiteuses:SetUses(TUNING.PEG_LEG_USES)
--
-- 	return inst
-- end

return Prefab( "spear_obsidian", obsidianfn, obsidian_assets),
	-- Prefab( "spear", basicfn, basic_assets),
	   -- Prefab( "common/inventory/spear_poison", poisonfn, poison_assets),

	   Prefab( "needlespear", needlefn, needle_assets)
	   -- Prefab( "common/inventory/peg_leg", peglegfn, pegleg_assets)
