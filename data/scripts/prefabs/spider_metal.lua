local assets =
{
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/spider_metal_build.zip"),
    Asset("SOUND", "sound/spider.fsb"),
}

local prefabs =
{
    "venom_gland",
    "monstermeat",
    "silk",
}

local brain = require "brains/spiderbrain"

local function ShouldAcceptItem(inst, item, giver)
    return giver:HasTag("spiderwhisperer") and inst.components.eater:CanEat(item)
end

function GetOtherSpiders(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    return TheSim:FindEntities(x, y, z, 15,  { "spider" }, { "FX", "NOCLICK", "DECOR", "INLIMBO" })
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.eater:CanEat(item) then
        inst.sg:GoToState("eat", true)

        local playedfriendsfx = false
        if inst.components.combat.target == giver then
            inst.components.combat:SetTarget(nil)
        elseif giver.components.leader ~= nil and
            inst.components.follower ~= nil then
            giver:PushEvent("makefriend")
            playedfriendsfx = true
            giver.components.leader:AddFollower(inst)
            inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.SPIDER_LOYALTY_PER_HUNGER)
        end

        if giver.components.leader ~= nil then
            local spiders = GetOtherSpiders(inst)
            local maxSpiders = 3

            for i, v in ipairs(spiders) do
                if maxSpiders <= 0 then
                    break
                end

                if v.components.combat.target == giver then
                    v.components.combat:SetTarget(nil)
                elseif giver.components.leader ~= nil and
                    v.components.follower ~= nil and
                    v.components.follower.leader == nil then
                    if not playedfriendsfx then
                        giver:PushEvent("makefriend")
                        playedfriendsfx = true
                    end
                    giver.components.leader:AddFollower(v)
                    v.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.SPIDER_LOYALTY_PER_HUNGER)
                end
                maxSpiders = maxSpiders - 1

                if v.components.sleeper:IsAsleep() then
                    v.components.sleeper:WakeUp()
                end
            end
        end
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("taunt")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
        end,
        { "_combat", "character" },
        { "monster", "INLIMBO" }
    )
end

local function NormalRetarget(inst)
    return FindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
end

local function keeptargetfn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and not (inst.components.follower ~= nil and
                (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

local function BasicWakeCheck(inst)
    return (inst.components.combat ~= nil and inst.components.combat.target ~= nil)
        or (inst.components.homeseeker ~= nil and inst.components.homeseeker:HasHome())
        or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
        or (inst.components.follower ~= nil and inst.components.follower.leader ~= nil)
end

local function ShouldSleep(inst)
    return TheWorld.state.iscaveday and not BasicWakeCheck(inst)
end

local function ShouldWake(inst)
    return not TheWorld.state.iscaveday
        or BasicWakeCheck(inst)
        or (inst:HasTag("spider_poisonous") and
            FindTarget(inst, TUNING.SPIDER_WARRIOR_WAKE_RADIUS) ~= nil)
end

local function DoReturn(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home ~= nil and
        home.components.childspawner ~= nil and
        not (inst.components.follower ~= nil and
            inst.components.follower.leader ~= nil) then
        home.components.childspawner:GoHome(inst)
    end
end

local function OnEntitySleep(inst)
    if TheWorld.state.iscaveday then
        DoReturn(inst)
    end
end

local function SummonFriends(inst, attacker)
    local den = GetClosestInstWithTag("spiderden_metal", inst, SpringCombatMod(TUNING.SPIDER_SUMMON_WARRIORS_RADIUS))
    if den ~= nil and den.components.combat ~= nil and den.components.combat.onhitfn ~= nil then
        den.components.combat.onhitfn(den, attacker)
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("spider")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
end

local function OnIsCaveDay(inst, iscaveday)
    if not iscaveday then
        inst.components.sleeper:WakeUp()
    elseif inst:IsAsleep() then
        DoReturn(inst)
    end
end

local function CalcSanityAura(inst, observer)
    return observer:HasTag("spiderwhisperer") and 0 or inst.components.sanityaura.aura
end

local function create_common(build, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetFourFaced()

    inst:AddTag("cavedweller")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("spider")
    --inst:AddTag("poisonous")
    if tag ~= nil then
        inst:AddTag(tag)
    end

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ----------

    inst.OnEntitySleep = OnEntitySleep

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }

    inst:SetStateGraph("SGmw_spider")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"ironnugget"})
    inst.components.lootdropper:AddChanceLoot("goldnugget", 0.35)
    inst.components.lootdropper:AddChanceLoot("gland", 0.40)
    -- inst.components.lootdropper:AddRandomHauntedLoot("venom_gland", 1)
    -- inst.components.lootdropper.numrandomloot = 1

    ---------------------
    -- MakeMediumBurnableCharacter(inst, "body")
    -- MakeMediumFreezableCharacter(inst, "body")
    -- inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetOnHit(SummonFriends)

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.TOTAL_DAY_TIME

    ------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    ------------------

    inst:AddComponent("knownlocations")

    ------------------

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    ------------------

    inst:AddComponent("inspectable")

    ------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    ------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    MakeHauntablePanic(inst)

    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)

    inst:WatchWorldState("iscaveday", OnIsCaveDay)
    OnIsCaveDay(inst, TheWorld.state.iscaveday)

    return inst
end

local function create_metal()
    local inst = create_common("spider_metal_build", "spider_metal")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.health:SetMaxHealth(175)

    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(2.5)
    inst.components.combat:SetRetargetFunction(2, NormalRetarget)

    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 4

    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE

    return inst
end

return Prefab("spider_metal", create_metal, assets, prefabs)
