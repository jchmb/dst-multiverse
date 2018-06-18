local assets =
{
	Asset("ANIM", "anim/armor_obsidian.zip"),
}

local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/armour/obsidian")
    if (data.weapon == nil or (not data.weapon:HasTag("projectile") and data.weapon.projectile == nil))
        and data.attacker and data.attacker.components.burnable
        and (data.attacker.components.combat == nil or (data.attacker.components.combat.defaultdamage > 0)) then

        data.attacker.components.burnable:Ignite()
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_obsidian", "swap_body")

    -- inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)

    if owner.components.health then
        owner.components.health.fire_damage_scale = owner.components.health.fire_damage_scale - TUNING.ARMORDRAGONFLY_FIRE_RESIST
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    -- inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)

    if owner.components.health then
        owner.components.health.fire_damage_scale = owner.components.health.fire_damage_scale + TUNING.ARMORDRAGONFLY_FIRE_RESIST
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    -- MakeInventoryFloatable(inst, "idle_water", "anim")

    -- inst.components.floatable:SetOnHitWaterFn(function(inst)
    --     inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/obsidian_wetsizzles")
    -- end)

    inst.AnimState:SetBank("armor_obsidian")
    inst.AnimState:SetBuild("armor_obsidian")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_obsidian.xml"
    inst.components.inventoryitem.foleysound = "dontstarve_DLC002/common/foley/obsidian_armour"

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
    inst.no_wet_prefix = true

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORDRAGONFLY, TUNING.ARMORDRAGONFLY_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    return inst
end

return Prefab( "armor_obsidian", fn, assets)
