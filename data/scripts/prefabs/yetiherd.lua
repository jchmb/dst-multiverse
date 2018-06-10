local prefabs =
{
    "yeti",
}

local MAX_YETI_HERD_SIZE = 12
local YETI_SPAWN_DELAY = 60 * 6
local YETI_SPAWN_DELAY_VARIANCE = YETI_SPAWN_DELAY * 0.5

local function CanSpawn(inst)
    return inst.components.herd ~= nil and not inst.components.herd:IsFull()
end

local function OnSpawned(inst, newent)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    --V2C: Don't use CLASSIFIED because herds use FindEntities on "herd" tag
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("yeti")
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetMaxSize(MAX_YETI_HERD_SIZE)
    --inst.components.herd:SetOnEmptyFn(inst.Remove)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(
        YETI_SPAWN_DELAY,
        YETI_SPAWN_DELAY_VARIANCE
    )
    inst.components.periodicspawner:SetPrefab("yeti")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 8)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    inst.components.periodicspawner:Start()

    return inst
end

return Prefab("yetiherd", fn, nil, prefabs)
