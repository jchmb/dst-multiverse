local assets =
{
    Asset("ANIM", "anim/pond_open.zip"),
    Asset("ANIM", "anim/splash.zip"),
}

local prefabs =
{
    "fish",
}

local function commonfn(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.95)

    inst.AnimState:SetBuild("pond_open")
    inst.AnimState:SetBank("pond_open")
    inst.AnimState:PlayAnimation("idle"..pondtype, true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.MiniMapEntity:SetIcon("minimap_pond"..pondtype..".tex")

    inst:AddTag("watersource")

    inst.no_wet_prefix = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.pondtype = pondtype

    inst.frozen = nil
    inst.plants = nil
    inst.plant_ents = nil

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "pond"

    inst:AddComponent("fishable")
    inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME * 1.5)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function OnInit(inst)
    inst.task = nil
end

local function pondopen()
    local inst = commonfn("_open")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.fishable:AddFish("fish")

    inst.task = inst:DoTaskInTime(0, OnInit)

    return inst
end

local function OnSpawnerInit(inst)
    inst.task = nil
    inst.components.childspawner:StartSpawning()
end

local function pondopenspawner()
    local inst = pondopen()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "crocodog_water"
    inst.components.childspawner:SetRegenPeriod(TUNING.POND_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.POND_SPAWN_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()

    inst.task = inst:DoTaskInTime(0, OnSpawnerInit)

    return inst
end

return Prefab("pond_open", pondopen, assets, prefabs),
    Prefab("pond_open_spawner", pondopenspawner, assets, prefabs)
