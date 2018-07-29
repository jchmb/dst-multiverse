local prefabs =
{
    "koalefant_cute",
    "carrodoy",
}

local function AddMember(inst, member)
    -- Nothing
end

local function SpawnableParent(inst)
    for member,_ in pairs(inst.components.herd.members) do
        -- Nothing
    end
    return nil
end

local function CanSpawn(inst)
    -- Note that there are other conditions inside periodic spawner governing this as well.

    if inst.components.herd == nil or inst.components.herd:IsFull() then
        return false
    end

    local found = SpawnableParent(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
    return found ~= nil
        and #TheSim:FindEntities(x, y, z, inst.components.herd.gatherrange, { "herdmember", inst.components.herd.membertag }) < TUNING.BEEFALOHERD_MAX_IN_RANGE
end

local function OnSpawned(inst, newent)
    --print("At ONSPAWNED",inst)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
    end
    local parent = SpawnableParent(inst)
    if parent ~= nil then
        newent.Transform:SetPosition(parent.Transform:GetWorldPosition())
    end
end

--local function OnFull(inst)
    --TODO: mark some beefalo for death
--end

local function OnInit(inst)
    -- Nothing yet
end

local function koalefant_cute_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    --V2C: Don't use CLASSIFIED because herds use FindEntities on "herd" tag
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("koalefant_cute")
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(30)
    inst.components.herd:SetOnEmptyFn(inst.Remove)
    --inst.components.herd:SetOnFullFn(OnFull)
    inst.components.herd:SetAddMemberFn(AddMember)

    inst:DoTaskInTime(0, OnInit)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(
        TUNING.BEEFALO_MATING_SEASON_BABYDELAY,
        TUNING.BEEFALO_MATING_SEASON_BABYDELAY_VARIANCE
    )
    inst.components.periodicspawner:SetPrefab("koalefant_cute")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 6)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)

    return inst
end

local function carrodoy_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    --V2C: Don't use CLASSIFIED because herds use FindEntities on "herd" tag
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("carrodoy")
    inst.components.herd:SetGatherRange(30)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetOnEmptyFn(inst.Remove)
    --inst.components.herd:SetOnFullFn(OnFull)
    inst.components.herd:SetAddMemberFn(AddMember)

    inst:DoTaskInTime(0, OnInit)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(
        TUNING.BEEFALO_MATING_SEASON_BABYDELAY,
        TUNING.BEEFALO_MATING_SEASON_BABYDELAY_VARIANCE
    )
    inst.components.periodicspawner:SetPrefab("carrodoy")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 6)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)

    return inst
end


return Prefab("koalefant_cute_herd", koalefant_cute_fn, nil, prefabs),
    Prefab("carrodoy_herd", carrodoy_fn, nil, prefabs)
