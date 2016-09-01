local assets=
{
	Asset("ANIM", "anim/ox_horn.zip"),
}

local function onfinished(inst)
    inst:Remove()
end

local function HearPanFlute(inst, musician, instrument)
	TheWorld:PushEvent("ms_forceprecipitation")
    -- GetWorld().components.seasonmanager:ForcePrecip()
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ox_horn")
    inst.AnimState:SetBuild("ox_horn")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    -- MakeInventoryFloatable(inst, "idle_water", "idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")
        
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ox_horn.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    return inst
end

return Prefab( "ox_horn", fn, assets) 