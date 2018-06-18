local brain = require "brains/koalefantbrain"

local assets =
{
    Asset("ANIM", "anim/koalefant_basic.zip"),
    Asset("ANIM", "anim/koalefant_actions.zip"),
    --Asset("ANIM", "anim/koalefant_build.zip"),
    Asset("ANIM", "anim/koalefant_summer_build.zip"),
    Asset("ANIM", "anim/koalefant_winter_build.zip"),
    Asset("SOUND", "sound/koalefant.fsb"),
}

local prefabs =
{
    "meat",
    "poop",
    "trunk_summer",
    "trunk_winter",
    "koalefant_cute_herd",
}

local loot_cute = {"meat","meat","meat","meat","meat"}

local WAKE_TO_RUN_DISTANCE = 10
local SLEEP_NEAR_ENEMY_DISTANCE = 14

local function ShouldWakeUp(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    return DefaultWakeTest(inst) or IsAnyPlayerInRange(x, y, z, WAKE_TO_RUN_DISTANCE)
end

local function ShouldSleep(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    return DefaultSleepTest(inst) and not IsAnyPlayerInRange(x, y, z, SLEEP_NEAR_ENEMY_DISTANCE)
end

local function KeepTarget(inst, target)
    return inst:IsNear(target, TUNING.KOALEFANT_CHASE_DIST)
end

local function IsAllied(dude)
    return dude:HasTag("koalefant") or dude:HasTag("manrabbit")
end

local function ShareTargetFn(dude)
    return IsAllied(dude) and not dude:HasTag("player") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 5)
end

local function create_base(build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 100, .75)

    inst.DynamicShadow:SetSize(4.5, 2)
    inst.Transform:SetSixFaced()

    inst:AddTag("koalefant")
    inst:AddTag("animal")
    inst:AddTag("largecreature")

    --saltlicker (from saltlicker component) added to pristine state for optimization
    inst:AddTag("saltlicker")

    inst.AnimState:SetBank("koalefant")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.KOALEFANT_DAMAGE)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.KOALEFANT_HEALTH)

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("poop")
    inst.components.periodicspawner:SetRandomTimes(40, 60)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:Start()

    inst:AddComponent("timer")
    inst:AddComponent("saltlicker")
    inst.components.saltlicker:SetUp(TUNING.SALTLICK_KOALEFANT_USES)

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")

    MakeHauntablePanic(inst)

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 1.5
    inst.components.locomotor.runspeed = 7

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:SetBrain(brain)
    inst:SetStateGraph("SGkoalefant")
    return inst
end

local function AddCuteMember(inst, member)
    -- Nothing
end

local function create_cute()
    local inst = create_base("koalefant_summer_build")

    inst:AddTag("koalefant_cute")
    inst:RemoveTag("largecreature")

    if not TheWorld.ismastersim then
        return inst
    end

    local s = 0.7
    inst.Transform:SetScale(s, s, s)
    -- inst.AnimState:SetAddColour(0.3, 0.1, 0.05, 0)

    inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("koalefant_cute_herd")
    inst.components.herdmember:Enable(true)

    inst.components.lootdropper:SetLoot(loot_cute)
    inst.components.lootdropper:AddRandomLoot("meat", 1)
    inst.components.lootdropper.numrandomloot = 1

    return inst
end

return Prefab("koalefant_cute", create_cute, assets, prefabs)
