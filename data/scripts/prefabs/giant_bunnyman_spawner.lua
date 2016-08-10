local prefabs =
{
    "giant_bunnyman",
}

local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_giant_bunnyman", TUNING.DRAGONFLY_RESPAWN_TIME)
end

local function GenerateNewGiantBunnyman(inst)
    inst.components.childspawner:AddChildrenInside(1)
    inst.components.childspawner:StartSpawning()
end

local function ontimerdone(inst, data)
    if data.name == "regen_giant_bunnyman" then
        GenerateNewGiantBunnyman(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "giant_bunnyman"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(1, 0)
    inst.components.childspawner.onchildkilledfn = OnKilled
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner:StopRegen()
    --inst.components.childspawner:SetSpawnedFn(onspawned)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)

    return inst
end

return Prefab("giant_bunnyman_spawner", fn, nil, prefabs)
