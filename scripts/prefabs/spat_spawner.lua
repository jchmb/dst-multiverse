local prefabs =
{
    "spat",
}

local MAX_SPAT_HERD_SIZE = 3
local SPAT_SPAWN_TIME = 60 * 14

--[[
local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_giant_bunnyman", TUNING.DRAGONFLY_RESPAWN_TIME)
end
--]]

local function GenerateNewSpat(inst)
    inst.components.childspawner:AddChildrenInside(1)
    inst.components.childspawner:StartSpawning()
end

--[[
local function ontimerdone(inst, data)
    if data.name == "regen_giant_bunnyman" then
        GenerateNewGiantBunnyman(inst)
    end
end
--]]

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "spat"
    inst.components.childspawner:SetMaxChildren(MAX_SPAT_HERD_SIZE)
    inst.components.childspawner:SetSpawnPeriod(SPAT_SPAWN_TIME, SPAT_SPAWN_TIME * 0.1)
    --inst.components.childspawner.onchildkilledfn = OnKilled
    inst.components.childspawner:StartSpawning()
    --inst.components.childspawner:StopRegen()
    --inst.components.childspawner:SetSpawnedFn(onspawned)

    --inst:AddComponent("timer")
    --inst:ListenForEvent("timerdone", ontimerdone)

    return inst
end

return Prefab("spat_spawner", fn, nil, prefabs)
