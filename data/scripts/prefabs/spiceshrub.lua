local assets =
{
    Asset("ANIM", "anim/quagmire_spiceshrub.zip"),
    Asset("ANIM", "anim/quagmire_spotspice_sprig.zip"),
    Asset("ANIM", "anim/quagmire_spotspice_ground.zip"),
}

local prefabs =
{
    "quagmire_spotspice_sprig",
}

local prefabs_ground =
{
    "quagmire_burnt_ingredients",
}

local function OnPicked(inst)
    inst.AnimState:PlayAnimation("picked")
    inst.AnimState:PushAnimation("empty")
end

local function MakeEmpty(inst)
    inst.AnimState:PlayAnimation("empty")
end

local function MakeFull(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle")
end

local function shrub_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("quagmire_spotspiceshrub.png")

    inst.AnimState:SetBuild("quagmire_spiceshrub")
    inst.AnimState:SetBank("quagmire_spiceshrub")
    inst.AnimState:PlayAnimation("idle", true)

    MakeObstaclePhysics(inst, .3)

    -- for stats tracking
    inst:AddTag("quagmire_wildplant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = MakeEmpty
    -- inst.components.pickable.makebarrenfn = MakeBarren
    inst.components.pickable.makefullfn = MakeFull
    inst.components.pickable:SetUp("spotspice_sprig", TUNING.BERRY_REGROW_TIME)
    -- inst.components.pickable.ontransplantfn = OnTransplant

    -- event_server_data("quagmire", "prefabs/quagmire_spiceshrub").master_postinit_shrub(inst)

    return inst
end

local function sprig_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_spotspice_sprig")
    inst.AnimState:SetBuild("quagmire_spotspice_sprig")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_spotspice_sprig"

    inst:AddComponent("bait")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    -- event_server_data("quagmire", "prefabs/quagmire_spiceshrub").master_postinit_sprig(inst)

    return inst
end

local function groundspice_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_spotspice_ground")
    inst.AnimState:SetBuild("quagmire_spotspice_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("spice")
    inst:AddTag("quagmire_stewable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_spotspice_ground"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("bait")

    -- event_server_data("quagmire", "prefabs/quagmire_spiceshrub").master_postinit_ground(inst)

    return inst
end

return Prefab("spotspice_shrub", shrub_fn, assets, prefabs),
    Prefab("spotspice_sprig", sprig_fn, assets),
    Prefab("spotspice_ground", groundspice_fn, assets, prefabs_ground)
