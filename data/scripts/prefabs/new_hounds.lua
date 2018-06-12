local assets =
{
    Asset("ANIM", "anim/hound_basic.zip"),
    Asset("ANIM", "anim/hound.zip"),
    Asset("ANIM", "anim/hound_slimey.zip"),
    Asset("ANIM", "anim/crocodog_basic.zip"),
    Asset("ANIM", "anim/crocodog.zip"),
    Asset("ANIM", "anim/crocodog_water.zip"),
    Asset("ANIM", "anim/crocodog_poison.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{
    "houndstooth",
    "monstermeat",
    "redgem",
    "bluegem",
    "mucus",
}

local prefabs_clay =
{
    "houndstooth",
    "redpouch",
    "eyeflame",
}

local gargoyles =
{
    "gargoyle_houndatk",
    "gargoyle_hounddeath",
}
local prefabs_moon = {}
for i, v in ipairs(gargoyles) do
    table.insert(prefabs_moon, v)
end
for i, v in ipairs(prefabs) do
    table.insert(prefabs_moon, v)
end

local brain = require("brains/houndbrain")
local moonbrain = require("brains/moonbeastbrain")

local sounds =
{
    pant = "dontstarve/creatures/hound/pant",
    attack = "dontstarve/creatures/hound/attack",
    bite = "dontstarve/creatures/hound/bite",
    bark = "dontstarve/creatures/hound/bark",
    death = "dontstarve/creatures/hound/death",
    sleep = "dontstarve/creatures/hound/sleep",
    growl = "dontstarve/creatures/hound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
}

local sounds_clay =
{
    pant = "dontstarve/creatures/together/clayhound/pant",
    attack = "dontstarve/creatures/together/clayhound/attack",
    bite = "dontstarve/creatures/together/clayhound/bite",
    bark = "dontstarve/creatures/together/clayhound/bark",
    death = "dontstarve/creatures/together/clayhound/death",
    sleep = "dontstarve/creatures/together/clayhound/sleep",
    growl = "dontstarve/creatures/together/clayhound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
}

SetSharedLootTable('hound',
{
    {'monstermeat', 1.000},
    {'houndstooth', 0.125},
})

SetSharedLootTable('hound_slimey',
{
    {'monstermeat', 1.000},
    {'mucus', 0.5},
})

SetSharedLootTable('crocodog',
{
    {'monstermeat', 1.000},
    {'houndstooth', 0.500},
    {'houndstooth', 0.250},
    -- {'venom_gland', 0.25},
})

SetSharedLootTable('crocodog_poison',
{
    {'monstermeat', 1.000},
    {'houndstooth', 0.500},
    {'venom_gland', 0.250},
})

SetSharedLootTable('crocodog_water',
{
    {'monstermeat', 1.000},
    {'houndstooth', 0.500},
    {'ice', 1.000},
    {'ice', 0.500},
    {'ice', 0.250},
    {'ice', 0.125},
    -- {'venom_gland', 0.25},
})

SetSharedLootTable('hound_fire',
{
    {'monstermeat', 1.0},
    {'houndstooth', 1.0},
    {'houndfire',   1.0},
    {'houndfire',   1.0},
    {'houndfire',   1.0},
    {'redgem',      0.2},
})

SetSharedLootTable('hound_cold',
{
    {'monstermeat', 1.0},
    {'houndstooth', 1.0},
    {'houndstooth', 1.0},
    {'bluegem',     0.2},
})

SetSharedLootTable('clayhound',
{
    {'redpouch',    0.2},
    {'houndstooth', 0.1},
})

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or (inst.components.follower and inst.components.follower.leader and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    return inst:HasTag("pet_hound")
        and not TheWorld.state.isday
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning())
        and (not inst.components.homeseeker or inst:IsNear(inst.components.homeseeker.home, SLEEP_NEAR_HOME_DISTANCE))
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function retargetfn(inst)
    if inst.sg:HasStateTag("statue") then
        return
    end
    local leader = inst.components.follower.leader
    if leader ~= nil and leader.sg ~= nil and leader.sg:HasStateTag("statue") then
        return
    end
    local playerleader = leader ~= nil and leader:HasTag("player")
    local ispet = inst:HasTag("pet_hound")
    return (leader == nil or
            (ispet and not playerleader) or
            inst:IsNear(leader, TUNING.HOUND_FOLLOWER_AGGRO_DIST))
        and FindEntity(
                inst,
                (ispet or leader ~= nil) and TUNING.HOUND_FOLLOWER_TARGET_DIST or TUNING.HOUND_TARGET_DIST,
                function(guy)
                    return guy ~= leader and inst.components.combat:CanTarget(guy)
                end,
                nil,
                { "wall", "houndmound", "hound", "houndfriend" }
            )
        or nil
end

local function KeepTarget(inst, target)
    if inst.sg:HasStateTag("statue") then
        return false
    end
    local leader = inst.components.follower.leader
    local playerleader = leader ~= nil and leader:HasTag("player")
    local ispet = inst:HasTag("pet_hound")
    return (leader == nil or
            (ispet and not playerleader) or
            inst:IsNear(leader, TUNING.HOUND_FOLLOWER_RETURN_DIST))
        and inst.components.combat:CanTarget(target)
        and (not (ispet or leader ~= nil) or
            inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP))
end

local function IsNearMoonBase(inst, dist)
    local moonbase = inst.components.entitytracker:GetEntity("moonbase")
    return moonbase == nil or inst:IsNear(moonbase, dist)
end

local function moon_retargetfn(inst)
    return IsNearMoonBase(inst, TUNING.MOONHOUND_AGGRO_DIST)
        and FindEntity(
                inst,
                TUNING.HOUND_FOLLOWER_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                nil,
                { "wall", "houndmound", "hound", "houndfriend", "moonbeast" }
            )
        or nil
end

local function moon_keeptargetfn(inst, target)
    return IsNearMoonBase(inst, TUNING.MOONHOUND_RETURN_DIST)
        and inst.components.combat:CanTarget(target)
        and inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("hound") or dude:HasTag("houndfriend"))
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end

local function RemoveSlimedEffect(target)
    target.components.locomotor:RemoveExternalSpeedMultiplier(target, "slimed")
end

local function SlowDownTarget(target)
    target.components.locomotor:SetExternalSpeedMultiplier(target, "slimed", 0.6)
    target:DoTaskInTime(3 + math.random() * 2, RemoveSlimedEffect)
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("hound") or dude:HasTag("houndfriend"))
                and data.target ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
    if inst:HasTag("slimey") and data.target ~= nil and data.target.components.locomotor then
        SlowDownTarget(data.target)
    end
end

local function GetReturnPos(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = 2
    local angle = math.random() * 2 * PI
    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function DoReturn(inst)
    --print("DoReturn", inst)
    if inst.components.homeseeker ~= nil and inst.components.homeseeker:HasHome() then
        if inst:HasTag("pet_hound") then
            if inst.components.homeseeker.home:IsAsleep() and not inst:IsNear(inst.components.homeseeker.home, HOME_TELEPORT_DIST) then
                inst.Physics:Teleport(GetReturnPos(inst.components.homeseeker.home))
            end
        elseif inst.components.homeseeker.home.components.childspawner ~= nil then
            inst.components.homeseeker.home.components.childspawner:GoHome(inst)
        end
    end
end

local function OnEntitySleep(inst)
    --print("OnEntitySleep", inst)
    if not TheWorld.state.isday then
        DoReturn(inst)
    end
end

local function OnStopDay(inst)
    --print("OnStopDay", inst)
    if inst:IsAsleep() then
        DoReturn(inst)
    end
end

local function OnSpawnedFromHaunt(inst)
    if inst.components.hauntable ~= nil then
        inst.components.hauntable:Panic()
    end
end

local function OnSave(inst, data)
    data.ispet = inst:HasTag("pet_hound") or nil
    --print("OnSave", inst, data.ispet)
end

local function OnLoad(inst, data)
    --print("OnLoad", inst, data.ispet)
    if data ~= nil and data.ispet then
        inst:AddTag("pet_hound")
        if inst.sg ~= nil then
            inst.sg:GoToState("idle")
        end
    end
end

local function OnClayRemoveEntity(inst)
    if inst.eyefxl ~= nil then
        inst.eyefxl:Remove()
        inst.eyefxl = nil
    end
    if inst.eyefxr ~= nil then
        inst.eyefxr:Remove()
        inst.eyefxr = nil
    end
end

local function GetStatus(inst)
    return (inst.sg:HasStateTag("statue") and "STATUE")
        or nil
end

local function OnEyeFlamesDirty(inst)
    if TheWorld.ismastersim then
        if not inst._eyeflames:value() then
            inst.AnimState:SetLightOverride(0)
            inst.SoundEmitter:KillSound("eyeflames")
        else
            inst.AnimState:SetLightOverride(.07)
            if not inst.SoundEmitter:PlayingSound("eyeflames") then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "eyeflames")
                inst.SoundEmitter:SetParameter("eyeflames", "intensity", 1)
            end
        end
        if TheNet:IsDedicated() then
            return
        end
    end

    if inst._eyeflames:value() then
        if inst.eyefxl == nil then
            inst.eyefxl = SpawnPrefab("eyeflame")
            inst.eyefxl.entity:AddFollower()
            inst.eyefxl.Follower:FollowSymbol(inst.GUID, "hound_eye_left", 0, 0, 0)
        end
        if inst.eyefxr == nil then
            inst.eyefxr = SpawnPrefab("eyeflame")
            inst.eyefxr.entity:AddFollower()
            inst.eyefxr.Follower:FollowSymbol(inst.GUID, "hound_eye_right", 0, 0, 0)
        end
    else
        if inst.eyefxl ~= nil then
            inst.eyefxl:Remove()
            inst.eyefxl = nil
        end
        if inst.eyefxr ~= nil then
            inst.eyefxr:Remove()
            inst.eyefxr = nil
        end
    end
end

local function OnStartFollowing(inst, data)
    if inst.leadertask ~= nil then
        inst.leadertask:Cancel()
        inst.leadertask = nil
    end
    if data == nil or data.leader == nil then
        inst.components.follower.maxfollowtime = nil
    elseif data.leader:HasTag("player") then
        inst.components.follower.maxfollowtime = TUNING.HOUNDWHISTLE_EFFECTIVE_TIME * 1.5
    else
        inst.components.follower.maxfollowtime = nil
        if inst.components.entitytracker:GetEntity("leader") == nil then
            inst.components.entitytracker:TrackEntity("leader", data.leader)
        end
    end
end

local function RestoreLeader(inst)
    inst.leadertask = nil
    local leader = inst.components.entitytracker:GetEntity("leader")
    if leader ~= nil and not leader.components.health:IsDead() then
        inst.components.follower:SetLeader(leader)
        leader:PushEvent("restoredfollower", { follower = inst })
    end
end

local function OnStopFollowing(inst)
    inst.leader_offset = nil
    if not inst.components.health:IsDead() then
        local leader = inst.components.entitytracker:GetEntity("leader")
        if leader ~= nil and not leader.components.health:IsDead() then
            inst.leadertask = inst:DoTaskInTime(.2, RestoreLeader)
        end
    end
end

local function fncommon(bank, build, morphlist, custombrain, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetFourFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("hound")
    inst:AddTag("canbestartled")

    if tag ~= nil then
        inst:AddTag(tag)

        if tag == "clay" then
            inst._eyeflames = net_bool(inst.GUID, "clayhound._eyeflames", "eyeflamesdirty")
            inst:ListenForEvent("eyeflamesdirty", OnEyeFlamesDirty)
            if not TheNet:IsDedicated() then
                inst.OnRemoveEntity = OnClayRemoveEntity
            end
        end
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = tag == "clay" and sounds_clay or sounds

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = tag == "slimey" and (0.7 * TUNING.HOUND_SPEED) or TUNING.HOUND_SPEED
    inst:SetStateGraph("SGhound")

    inst:SetBrain(custombrain or brain)

    inst:AddComponent("follower")
    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.HOUND_HEALTH)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.HOUND_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetHurtSound("dontstarve/creatures/hound/hurt")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable(build)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    if tag == "clay" then
        inst.sg:GoToState("statue")

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    else
        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
        inst.components.eater:SetCanEatHorrible()
        inst.components.eater.strongstomach = true -- can eat monster meat!

        inst:AddComponent("sleeper")
        inst.components.sleeper:SetResistance(3)
        inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
        inst.components.sleeper:SetSleepTest(ShouldSleep)
        inst.components.sleeper:SetWakeTest(ShouldWakeUp)
        inst:ListenForEvent("newcombattarget", OnNewTarget)

        if morphlist ~= nil then
            MakeHauntableChangePrefab(inst, morphlist)
            inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)
        else
            MakeHauntablePanic(inst)
        end
    end

    inst:WatchWorldState("stopday", OnStopDay)
    inst.OnEntitySleep = OnEntitySleep

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)
    inst:ListenForEvent("startfollowing", OnStartFollowing)
    inst:ListenForEvent("stopfollowing", OnStopFollowing)

    return inst
end

local function fnslimey()
    local inst = fncommon("hound", "hound_slimey", {"hound_slimey"}, nil, "slimey")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE * 0.8)

    MakeMediumFreezableCharacter(inst, "hound_body")
    MakeMediumBurnableCharacter(inst, "hound_body")

    return inst
end

local function fncroco()
    local inst = fncommon("crocodog", "crocodog", {"crocodog"}, nil, "crocodile")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE * 1.2)
    -- inst:AddComponent("poisonous")

    MakeMediumFreezableCharacter(inst, "hound_body")
    MakeMediumBurnableCharacter(inst, "hound_body")

    return inst
end

local function fncrocopoison()
    local inst = fncommon("crocodog", "crocodog_poison", {"crocodog_water", "crocodog_poison"}, nil, "crocodile")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst:AddComponent("poisonous")

    MakeMediumFreezableCharacter(inst, "hound_body")
    MakeMediumBurnableCharacter(inst, "hound_body")

    return inst
end

local function fncrocowater()
    local inst = fncommon("crocodog", "crocodog_water", {"crocodog_water", "crocodog_poison"}, nil, "crocodile")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    -- inst:AddComponent("poisonous")

    MakeMediumFreezableCharacter(inst, "hound_body")
    MakeMediumBurnableCharacter(inst, "hound_body")

    return inst
end

return Prefab("hound_slimey", fnslimey, assets, prefabs),
    Prefab("crocodog", fncroco, assets, prefabs),
    Prefab("crocodog_poison", fncrocopoison, assets, prefabs),
    Prefab("crocodog_water", fncrocowater, assets, prefabs)
