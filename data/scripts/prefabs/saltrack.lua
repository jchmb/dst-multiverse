local assets =
{
    Asset("ANIM", "anim/quagmire_salt_rack.zip"),
}

local prefabs =
{
    "quagmire_salt_rack_item",
    "quagmire_saltrock",
    "collapse_small",
    "splash",
}

local prefabs_item =
{
    "quagmire_salt_rack",
}

local function OnHarvest(inst, picker, produce)
    inst.AnimState:Hide("salt")
end

local function OnExtract(inst, produce)
    if produce > 0 then
        inst.AnimState:Show("salt")
        inst.AnimState:PlayAnimation("grow")
        inst.AnimState:PushAnimation("idle")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("quagmire_salt_rack")
    inst.AnimState:SetBuild("quagmire_salt_rack")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:Hide("salt")

    MakeObstaclePhysics(inst, 1.95)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("saltextractor")
    inst.components.saltextractor:SetUp(
        OnHarvest,
        OnExtract
    )

    -- event_server_data("quagmire", "prefabs/quagmire_salt_rack").master_postinit(inst)

    return inst
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_pot_hanger")
    inst.AnimState:SetBuild("quagmire_pot_hanger")
    inst.AnimState:PlayAnimation("item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_salt_rack_item"

    inst:AddComponent("saltextractor_installable")
    inst.components.saltextractor_installable:SetUp("salt_rack")

    -- event_server_data("quagmire", "prefabs/quagmire_salt_rack").master_postinit_item(inst)

    return inst
end

return Prefab("salt_rack", fn, assets, prefabs),
    Prefab("salt_rack_item", itemfn, assets, prefabs_item)
