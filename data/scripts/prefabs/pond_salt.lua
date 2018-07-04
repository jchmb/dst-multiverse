local assets =
{
    Asset("ANIM", "anim/quagmire_salt_pond.zip"),
    Asset("ANIM", "anim/splash.zip"),
}

local prefabs =
{
    "quagmire_salmon",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.95)

    inst.AnimState:SetBuild("quagmire_salt_pond")
    inst.AnimState:SetBank("quagmire_salt_pond")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("saltpond")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("saltpond")
    inst.components.saltpond:SetUp(
        "saltrock",
        15
    )

    inst:AddComponent("fishable")
    inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
    inst.components.fishable:AddFish("salmon")

    -- event_server_data("quagmire", "prefabs/quagmire_pond").master_postinit(inst)

    return inst
end

return Prefab("pond_salt", fn, assets, prefabs)
