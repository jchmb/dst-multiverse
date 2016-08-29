local assets=
{
	Asset("ANIM", "anim/umbrella.zip"),
	Asset("ANIM", "anim/swap_umbrella.zip"),
    Asset("ANIM", "anim/swap_parasol.zip"),
    Asset("ANIM", "anim/parasol.zip"),
    Asset("ANIM", "anim/swap_parasol_palmleaf.zip"),
    Asset("ANIM", "anim/parasol_palmleaf.zip"),
}

local function onfinished(inst)
    inst:Remove()
end

local function UpdateSound(inst)
    return -- TODO
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_umbrella", "swap_umbrella")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    UpdateSound(inst)
    
    owner.DynamicShadow:SetSize(2.2, 1.4)

    inst.components.fueled:StartConsuming()
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    UpdateSound(inst)

    owner.DynamicShadow:SetSize(1.3, 0.6)

    inst.components.fueled:StopConsuming()
end

local function onperish(inst)
    if inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() then
        local owner = inst.components.inventoryitem.owner
        inst:Remove()
        
        if owner then
            owner:PushEvent("umbrellaranout")
        end
    else
        inst:Remove()
    end
end    
    
local function common_fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst:AddTag("nopunch")
    inst:AddTag("umbrella")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("waterproofer")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()

 --    inst:ListenForEvent("rainstop", function() UpdateSound(inst) end, GetWorld()) 
	-- inst:ListenForEvent("rainstart", function() UpdateSound(inst) end, GetWorld()) 

 --    inst:ListenForEvent("startrowing", function() UpdateSound(inst) end)
 --    inst:ListenForEvent("stoprowing", function() UpdateSound(inst) end)

    return inst
end

local function onequip_palmleaf(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_parasol_palmleaf", "swap_parasol_palmleaf")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    UpdateSound(inst)
    
    owner.DynamicShadow:SetSize(1.7, 1)
end

local function onunequip_palmleaf(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    UpdateSound(inst)

    owner.DynamicShadow:SetSize(1.3, 0.6)
end

local function palmleaf(Sim)
    local inst = common_fn()   
    inst.AnimState:SetBank("parasol_palmleaf")
    inst.AnimState:SetBuild("parasol_palmleaf")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.GRASS_UMBRELLA_PERISHTIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)
    inst:AddTag("show_spoilage")

    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

    inst.components.equippable:SetOnEquip( onequip_palmleaf )
    inst.components.equippable:SetOnUnequip( onunequip_palmleaf )

    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeDragonflyBait(inst, 3)

    inst.components.inventoryitem.atlasname = "images/inventoryimages/palmleaf_umbrella.xml"

    return inst
end

return Prefab( "palmleaf_umbrella", palmleaf, assets)