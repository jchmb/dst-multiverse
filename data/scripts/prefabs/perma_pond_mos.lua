local assets =
{
    Asset("ANIM", "anim/marsh_tile.zip"),
    Asset("ANIM", "anim/splash.zip"),
}

local prefabs =
{
    "marsh_plant",
    "perma_mosquito",
}

local function SpawnPlants(inst)
    inst.task = nil

    if inst.plant_ents ~= nil then
        return
    end

    if inst.plants == nil then
        inst.plants = {}
        for i = 1, math.random(2, 4) do
            local theta = math.random() * 2 * PI
            table.insert(inst.plants,
            {
                offset =
                {
                    math.sin(theta) * 1.9 + math.random() * .3,
                    0,
                    math.cos(theta) * 2.1 + math.random() * .3,
                },
            })
        end
    end

    inst.plant_ents = {}

    for i, v in pairs(inst.plants) do
        if type(v.offset) == "table" and #v.offset == 3 then
            local plant = SpawnPrefab(inst.planttype)
            if plant ~= nil then
                plant.entity:SetParent(inst.entity)
                plant.Transform:SetPosition(unpack(v.offset))
                plant.persists = false
                table.insert(inst.plant_ents, plant)
            end
        end
    end
end

local function DespawnPlants(inst)
    if inst.plant_ents ~= nil then
        for i, v in ipairs(inst.plant_ents) do
            if v:IsValid() then
                v:Remove()
            end
        end

        inst.plant_ents = nil
    end

    inst.plants = nil
end

local function OnSave(inst, data)
    data.plants = inst.plants
end

local function OnLoad(inst, data)
    if data ~= nil and data.plants ~= nil and inst.plants == nil and inst.task ~= nil then
        inst.plants = data.plants
    end
end

local function commonfn(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.95)

    inst.AnimState:SetBuild("marsh_tile")
    inst.AnimState:SetBank("marsh_tile")
    inst.AnimState:PlayAnimation("idle"..pondtype, true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.MiniMapEntity:SetIcon("pond"..pondtype..".png")

    inst:AddTag("watersource")

    inst.no_wet_prefix = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.pondtype = pondtype

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(TUNING.POND_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.POND_SPAWN_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(3, 4))
    inst.components.childspawner:StartRegen()

    inst.frozen = nil
    inst.plants = nil
    inst.plant_ents = nil

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "pond"

    inst:AddComponent("fishable")
    inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function OnInit(inst)
    inst.task = nil
end

local function pondmos()
    local inst = commonfn("_mos")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.childspawner.childname = "perma_mosquito"
    inst.components.childspawner:StartSpawning()
    inst.components.fishable:AddFish("fish")

    inst.planttype = "marsh_plant"
    inst.task = inst:DoTaskInTime(0, OnInit)

    return inst
end 

return Prefab("perma_pond_mos", pondmos, assets, prefabs)