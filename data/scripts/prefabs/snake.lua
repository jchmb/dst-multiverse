local trace = function() end

local assets=
{
	Asset("ANIM", "anim/snake_build.zip"),
	Asset("ANIM", "anim/snake_yellow_build.zip"),
	Asset("ANIM", "anim/snake_basic.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}



local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = {"FX", "NOCLICK","DECOR","INLIMBO"}

local function ShouldWakeUp(inst)
	return not TheWorld.state.iscaveday
           or (inst.components.combat and inst.components.combat.target)
           or (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           or (inst.components.burnable and inst.components.burnable:IsBurning() )
           or (inst.components.follower and inst.components.follower.leader)
end

local function ShouldSleep(inst)
	return TheWorld.state.iscaveday
           and not (inst.components.combat and inst.components.combat.target)
           and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           and not (inst.components.burnable and inst.components.burnable:IsBurning() )
           and not (inst.components.follower and inst.components.follower.leader)
end

local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end


local function retargetfn(inst)
	local dist = TUNING.SPIDER_TARGET_DIST
	local notags = {"FX", "NOCLICK","INLIMBO", "wall", "snake", "structure"}
	return FindEntity(inst, dist, function(guy)
		return  inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (TUNING.SPIDER_TARGET_DIST*TUNING.SPIDER_TARGET_DIST*4*4) and not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(
		data.attacker,
		SHARE_TARGET_DIST,
		function(dude)
			return dude:HasTag("snake") and not dude.components.health:IsDead()
		end,
		5
	)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(
		data.target,
		SHARE_TARGET_DIST,
		function(dude)
			return dude:HasTag("snake") and not dude.components.health:IsDead()
		end,
		5
	)
end

local function DoReturn(inst)
	--print("DoReturn", inst)
	if inst.components.homeseeker and inst.components.homeseeker:HasHome()  then
		inst.components.homeseeker.home.components.spawner:GoHome(inst)
	end
end

local function OnDay(inst)
	--print("OnNight", inst)
	-- if inst:IsAsleep() then
		DoReturn(inst)
	-- end
end


local function OnEntitySleep(inst)
	--print("OnEntitySleep", inst)
	-- if TheWorld.state.iscaveday then
	-- 	DoReturn(inst)
	-- end
end

local function SanityAura(inst, observer)

    if observer.prefab == "webber" then
        return 0
    end

    return -TUNING.SANITYAURA_SMALL
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	--shadow:SetSize( 2.5, 1.5 )
	inst.Transform:SetFourFaced()

	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("snake")

	MakeCharacterPhysics(inst, 10, .5)

	anim:SetBank("snake")
	anim:SetBuild("snake_build")
	anim:PlayAnimation("idle")
	--inst.AnimState:SetRayTestOnBB(true)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("knownlocations")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = 3
	inst:SetStateGraph("SGsnake")

	local brain = require "brains/snakebrain"
	inst:SetBrain(brain)

	inst:AddComponent("follower")

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
	inst.components.eater:SetCanEatHorrible()

	inst.components.eater.strongstomach = true -- can eat monster meat!

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)
	--inst.components.health.poison_damage_scale = 0 -- immune to poison


	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(10)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRetargetFunction(3, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetHurtSound("dontstarve/creatures/spider/hurt")
	inst.components.combat:SetRange(2,3)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"monstermeat"})
	inst.components.lootdropper:AddChanceLoot("snakeskin", 0.25)
	inst.components.lootdropper.numrandomloot = 0

	inst:AddComponent("inspectable")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetNocturnal(true)
	--inst.components.sleeper:SetResistance(1)
	-- inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	-- inst.components.sleeper:SetSleepTest(ShouldSleep)
	-- inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	inst:ListenForEvent("newcombattarget", OnNewTarget)

	-- inst:ListenForEvent( "dusktime", function() OnNight( inst ) end, GetWorld())
	-- inst:ListenForEvent( "nighttime", function() OnNight( inst ) end, GetWorld())
	-- inst:ListenForEvent( "daytime", function() OnDay( inst ) end, GetWorld())
	-- inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

	MakeMediumFreezableCharacter(inst, "hound_body")

	return inst
end

local function commonfn()
	local inst = fn()

	--MakePoisonableCharacter(inst)
	MakeMediumBurnableCharacter(inst, "hound_body")

	return inst
end

local function poisonfn()
	local inst = fn()

	inst.AnimState:SetBuild("snake_yellow_build")
	--inst.components.combat.poisonous = true

	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("poisonous")

	inst.components.lootdropper:AddChanceLoot("venom_gland", 0.25)

	MakeMediumBurnableCharacter(inst, "hound_body")

	return inst
end

return Prefab("snake", commonfn, assets, prefabs),
	   Prefab("snake_poison", poisonfn, assets, prefabs)
