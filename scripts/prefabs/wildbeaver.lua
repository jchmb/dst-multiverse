local assets = {
    
}

local prefabs = {
    "log",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function CalcSanityAura(inst, observer)
    return (inst.components.werebeast ~= nil and inst.components.werebeast:IsInWereState() and -TUNING.SANITYAURA_LARGE)
        or (inst.components.follower ~= nil and inst.components.follower.leader == observer and TUNING.SANITYAURA_SMALL)
        or 0
end

local function ShouldAcceptItem(inst, item)
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    elseif item.components.edible ~= nil then
        local foodtype = item.components.edible.foodtype
        if foodtype == FOODTYPE.MEAT or foodtype == FOODTYPE.HORRIBLE then
            return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= 0.9
        elseif foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.RAW then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            return (last_eat_time == nil or
                    last_eat_time >= TUNING.PIG_MIN_POOP_PERIOD)
                and (inst.components.inventory == nil or
                    not inst.components.inventory:Has(item.prefab, 1))
        end
        return true
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    --I eat food
    if item.components.edible ~= nil then
        --meat makes us friends (unless I'm a guard)
        if item.components.edible.foodtype == FOODTYPE.MEAT or item.components.edible.foodtype == FOODTYPE.HORRIBLE then
            if inst.components.combat:TargetIs(giver) then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader ~= nil then
                giver:PushEvent("makefriend")
                giver.components.leader:AddFollower(inst)
                inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
                inst.components.follower.maxfollowtime =
                    giver:HasTag("polite")
                    and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                    or TUNING.PIG_LOYALTY_MAXTIME
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end

    --I wear hats
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnEat(inst, food)
    if food.components.edible ~= nil then
        if food.components.edible.foodtype == FOODTYPE.VEGGIE then
            SpawnPrefab("spoiled_food").Transform:SetPosition(inst.Transform:GetWorldPosition())
        elseif food.components.edible.foodtype == FOODTYPE.MEAT and
            inst.components.werebeast ~= nil and
            not inst.components.werebeast:IsInWereState() and
            food.components.edible:GetHealth(inst) < 0 then
            inst.components.werebeast:TriggerDelta(1)
        end
    end
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    inst:ClearBufferedAction()

    if attacker.prefab == "deciduous_root" and attacker.owner ~= nil then 
        OnAttackedByDecidRoot(inst, attacker.owner)
    elseif attacker.prefab ~= "deciduous_root" then
        inst.components.combat:SetTarget(attacker)

        if inst:HasTag("werepig") then
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsWerePig, MAX_TARGET_SHARES)
        elseif inst:HasTag("guard") then
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, attacker:HasTag("pig") and IsGuardPig or IsPig, MAX_TARGET_SHARES)
        elseif not (attacker:HasTag("pig") and attacker:HasTag("guard")) then
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsNonWerePig, MAX_TARGET_SHARES)
        end
    end
end

local function OnNewTarget(inst, data)
    if inst:HasTag("werepig") then
        inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, IsWerePig, MAX_TARGET_SHARES)
    end
end

local function NormalRetargetFn(inst)
    return FindEntity(
        inst,
        TUNING.PIG_TARGET_DIST,
        function(guy)
            return ((guy.LightWatcher == nil or guy.LightWatcher:IsInLight())
                and inst.components.combat:CanTarget(guy))
                
                -- Graypigs attack you if you are a monster (as usual), or if your sanity aura is less than 25%
       		and (guy:HasTag("monster") or (guy.components.sanity ~= nil and guy.components.sanity:GetPercentWithPenalty() <= 0.4))
        end,
        {"_combat"}, -- see entityreplica.lua
        inst.components.follower.leader ~= nil and
        { "playerghost", "INLIMBO", "abigail" } or
        { "playerghost", "INLIMBO" }
    )
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
        and (target.LightWatcher == nil or target.LightWatcher:IsInLight())
        and not (target.sg ~= nil and target.sg:HasStateTag("transform"))
end

local function NormalShouldSleep(inst)
    return DefaultSleepTest(inst)
        and (inst.components.follower == nil or inst.components.follower.leader == nil
            or (FindEntity(inst, 6, nil, { "campfire", "fire" }) ~= nil and
                (inst.LightWatcher == nil or inst.LightWatcher:IsInLight())))
end

local function GetStatus(inst)
    return (inst.components.follower.leader ~= nil and "FOLLOWER")
        or nil
end

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()
    
    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst:AddTag("character")
    inst:AddTag("wildbeaver")
    inst:AddTag("scarytoprey")
    
    inst.AnimState:SetBank("pigman")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")
    
    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    --Sneak these into pristine state for optimization
    inst:AddTag("_named")
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
     --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    
    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED
    
    inst:SetBrain(normalbrain)
    inst:SetStateGraph("SGpig")
    inst.components.sleeper:SetResistance(2)

    inst:AddComponent("bloomer")
    
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.WOODIE }, { FOODGROUP.WOODIE })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)
    
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)

    MakeMediumBurnableCharacter(inst, "pig_torso")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.PIGNAMES
    inst.components.named:PickNewName()
    
     MakeHauntablePanic(inst)
     
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
    ------------------------------------------

    inst:AddComponent("inventory")

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"meat", "log", "twigs"})
    inst.components.lootdropper.numrandomloot = 0
    inst.components.lootdropper:AddChanceLoot("twigs", 0.5)

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false
    inst.components.trader:Enable()
    
    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------

    inst:AddComponent("sleeper")

    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "pig_torso")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    
    return inst
end

return Prefab("wildbeaver", fn, assets, prefabs)
