--Need to make this enemy much less player focused.
--Doesn't target player by default.
    --Only if hit or if sharkittens threatened.

local assets =
{
	Asset("ANIM", "anim/tigershark_build.zip"),
    Asset("ANIM", "anim/tigershark_ground_build.zip"),
	Asset("ANIM", "anim/tigershark_ground.zip"),
    Asset("ANIM", "anim/tigershark_water_build.zip"),
	Asset("ANIM", "anim/tigershark_water.zip"),
    --Asset("ANIM", "anim/tigershark.zip"),
	Asset("ANIM", "anim/tigershark_water_ripples_build.zip"),
}

local prefabs =
{
	"tigersharkshadow",
    "splash_water_big",
    "groundpound_fx",
    "groundpoundring_fx",
    "mysterymeat",
    "fish_raw",
    "tigereye",
    "shark_gills",
}

SetSharedLootTable('tigershark',
{
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},
    {"fish_raw", 1.00},

    {"tigereye", 1.00},
    {"tigereye", 0.50},

    {"shark_gills", 1.00},
    {"shark_gills", 1.00},
    {"shark_gills", 0.33},
    {"shark_gills", 0.10},
})

local TARGET_DIST = 20
local HEALTH_THRESHOLD = 0.1
local HOME_PROTECTION_DISTANCE = 60

local brain = require "brains/tigersharkbrain"

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function GetTarget(inst)
    --Used for logic of moving between land and water states
    local target = inst.components.combat.target and inst.components.combat.target:GetPosition()

    if not target and inst:GetBufferedAction() then
        target = (inst:GetBufferedAction().target and inst:GetBufferedAction().target:GetPosition()) or inst:GetBufferedAction().pos
    end

    --Returns a position
    return target
end

local function GroundTypesMatch(inst, target)
    local target = target or GetTarget(inst)

    if target then
        if target.prefab then
            return inst:HasTag("aquatic") == target:HasTag("aquatic")
        elseif target.x and target.y and target.z then
            local tar_tile = GetMap():GetTileAtPoint(target:Get())
            return WorldSim:IsWater(tar_tile) == inst:GetIsOnWater()
        end
    end

    return true
end

local function FindSharkHome(inst)
    if not inst.sharkHome then
        if GetWorld().components.tigersharker and GetWorld().components.tigersharker.shark_home then
            inst.sharkHome = GetWorld().components.tigersharker.shark_home
        else
            inst.sharkHome = GetClosestInstWithTag("sharkhome", inst, 10000)
        end
    end
    return inst.sharkHome
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function RetargetFn(inst)
    local home = FindSharkHome(inst)

    if home and home:GetPosition():Dist(inst:GetPosition()) < HOME_PROTECTION_DISTANCE then
        --Aggressive to the player if close to home
        return FindEntity(inst, TARGET_DIST, 
            function(tar) return inst.components.combat:CanTarget(tar) end, nil, 
            {"prey", "smallcreature", "bird", "butterfly", "sharkitten"})
    elseif inst.components.health:GetPercent() > HEALTH_THRESHOLD then
        --Not aggressive to the player if far from home
        return FindEntity(inst, TARGET_DIST, 
            function(tar) return inst.components.combat:CanTarget(tar) end, nil,
            {"prey", "smallcreature", "bird", "butterfly", "sharkitten", "player", "companion"})
    end
end

local function KeepTargetFn(inst, target)
    --If this thing is close to my kittens keep target no matter what.
    local home = FindSharkHome(inst)
    if inst.components.health:GetPercent() < HEALTH_THRESHOLD and home and home:GetPosition():Dist(inst:GetPosition()) > HOME_PROTECTION_DISTANCE then
        --If I'm low health & not protecting my home, flee.
        return false
    else
        return inst.components.combat:CanTarget(target)
    end
end

local function ontimerdone(inst, data)
    if data.name == "Run" then
        inst.CanRun = true
    end
end

local function MakeWater(inst)
    inst:ClearStateGraph()
    inst:SetStateGraph("SGtigershark_water")
    inst.AnimState:SetBuild("tigershark_water_build")
    inst.AnimState:AddOverrideBuild("tigershark_water_ripples_build")
    inst:AddTag("aquatic")
    inst.DynamicShadow:Enable(false)
end

local function MakeGround(inst)
    inst:ClearStateGraph()
    inst:SetStateGraph("SGtigershark_ground")
    inst.AnimState:SetBuild("tigershark_ground_build")
    inst:RemoveTag("aquatic")
    inst.DynamicShadow:Enable(true)
end

local function OnSave(inst, data)
    data.CanRun = inst.CanRun
    data.NextFeedTime = GetTime() - inst.NextFeedTime
end

local function OnLoad(inst, data)
    if data then
        inst.CanRun = data.CanRun or true
        inst.NextFeedTime = data.NextFeedTime or 0
    end
end

local function CanBeAttacked(inst, attacker)
    return not inst.sg:HasStateTag("specialattack")
end

local function fn()

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.Transform:SetFourFaced()
    inst.DynamicShadow:SetSize( 6, 3 )
    inst.DynamicShadow:Enable(false)

    inst:AddTag("aquatic")
    inst:AddTag("scarytoprey")
    inst:AddTag("tigershark")
    inst:AddTag("largecreature")
    inst:AddTag("epic")

    MakePoisonableCharacter(inst)
    MakeCharacterPhysics(inst, 1000, 1.33)

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.TIGERSHARK_WALK_SPEED
	inst.components.locomotor.runspeed = TUNING.TIGERSHARK_RUN_SPEED

    inst:AddComponent("rowboatwakespawner")

    inst.AnimState:SetBank("tigershark")
    inst.AnimState:SetBuild("tigershark_water_build")
    inst.AnimState:PlayAnimation("water_run", true)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:AddOverrideBuild("tigershark_water_ripples_build")

    inst:AddComponent("inspectable")
    inst.no_wet_prefix = true

	inst:AddComponent("knownlocations")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TIGERSHARK_HEALTH)

    inst:AddComponent("eater")
    inst.components.eater.foodprefs = { "MEAT" }
    inst.components.eater.ablefoods = { "MEAT", "VEGGIE", "GENERIC" }

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('tigershark')

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 3
    inst.components.groundpounder.destructionRings = 1
    inst.components.groundpounder.numRings = 3
    inst.components.groundpounder.noTags = {"sharkitten"}

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.TIGERSHARK_DAMAGE)
    inst.components.combat:SetRange(TUNING.TIGERSHARK_ATTACK_RANGE, TUNING.TIGERSHARK_ATTACK_RANGE)
    inst.components.combat:SetAreaDamage(TUNING.TIGERSHARK_SPLASH_RADIUS, TUNING.TIGERSHARK_SPLASH_DAMAGE/TUNING.TIGERSHARK_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.TIGERSHARK_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/bearger/hurt")
    inst.components.combat.canbeattackedfn = CanBeAttacked
    inst.components.combat.notags = {"sharkitten"}

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    inst:ListenForEvent("killed", function(inst, data)
        if inst.components.combat and data and data.victim == inst.components.combat.target then
            inst.components.combat.target = nil
        end
    end)

    inst.CanRun = true --Can do charge attack

    inst.CanFly = false --Can do leap attack

    --[[
        - While in water, tigershark jumps every third attack.
        - While on ground, tigershark *can* jump after every third attack, but will
            only jump to close distance.

        This logic is controlled through the tigershark's stategraphs.
    --]]

    inst.AttackCounter = 0
    inst.NextFeedTime = 0
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.GroundTypesMatch = GroundTypesMatch
    inst.FindSharkHome = FindSharkHome
    inst.GetTarget = GetTarget
    inst.MakeGround = MakeGround
    inst.MakeWater = MakeWater

    inst:SetStateGraph("SGtigershark_water")
    inst:SetBrain(brain)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:DoTaskInTime(1*FRAMES, function()
        if inst:GetIsOnWater() then
            MakeWater(inst)
            inst.sg:GoToState("idle")
        else
            MakeGround(inst)
            inst.sg:GoToState("idle")
        end
    end)

	return inst
end

return Prefab( "ocean/objects/tigershark", fn, assets, prefabs)