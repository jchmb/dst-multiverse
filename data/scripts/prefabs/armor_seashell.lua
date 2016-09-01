local assets=
{
	Asset("ANIM", "anim/armor_seashell.zip"),
}

local function OnBlocked(owner) 
    -- TODO: owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/armour/shell") 
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_seashell", "swap_body")
    -- inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    -- inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    -- MakeInventoryFloatable(inst, "idle_water", "anim")
    
    inst.AnimState:SetBank("armor_seashell")
    inst.AnimState:SetBuild("armor_seashell")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    --inst:AddTag("wood")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_seashell.xml"
    -- TODO: inst.components.inventoryitem.foleysound = "dontstarve_DLC002/common/foley/seashell_suit"

    --inst:AddComponent("fuel")
    --inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeDragonflyBait(inst, 3)
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORSEASHELL, TUNING.ARMORSEASHELL_ABSORPTION)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    -- TODO: inst.components.equippable.poisonblocker = true
    
    return inst
end

return Prefab( "armor_seashell", fn, assets) 