local brain = require "brains/oxbrain"
require "stategraphs/SGox"

local assets=
{
	Asset("ANIM", "anim/ox_basic.zip"),
	Asset("ANIM", "anim/ox_actions.zip"),
	Asset("ANIM", "anim/ox_build.zip"),

	Asset("ANIM", "anim/ox_basic_water.zip"),
	Asset("ANIM", "anim/ox_actions_water.zip"),

	Asset("ANIM", "anim/ox_heat_build.zip"),
	Asset("SOUND", "sound/beefalo.fsb"),
}

local prefabs =
{
	-- "meat",
	-- "poop",
	--"ox_horn",
	--"horn",
}

SetSharedLootTable( 'ox',
{
	{'meat',            1.00},
	{'meat',            1.00},
	{'meat',            1.00},
	{'meat',            1.00},
	{'ox_horn',            0.33},
})

local sounds = 
{
	angry = "dontstarve/beefalo/angry",
	curious = "dontstarve/beefalo/curious",
	
	attack_whoosh = "dontstarve/beefalo/attack_whoosh",
	chew = "dontstarve/beefalo/chew",
	grunt = "dontstarve/beefalo/grunt",
	hairgrow_pop = "dontstarve/beefalo/hairgrow_pop",
	hairgrow_vocal = "dontstarve/beefalo/hairgrow_vocal",
	sleep = "dontstarve/beefalo/sleep",
	tail_swish = "dontstarve/beefalo/tail_swish",
	walk_land = "dontstarve/beefalo/walk",

	death = "dontstarve/beefalo/death",
	mating_call = "dontstarve/beefalo/yell",
}

local function OnEnterMood(inst)
	if inst.components.beard and inst.components.beard.bits > 0 then
		inst.AnimState:SetBuild("ox_heat_build")
		inst.AnimState:SetBank("ox")
		inst:AddTag("scarytoprey")
	end
end

local function OnLeaveMood(inst)
	if inst.components.beard and inst.components.beard.bits > 0 then
		inst.AnimState:SetBuild("ox_build")
		inst.AnimState:SetBank("ox")
		inst:RemoveTag("scarytoprey")
	end
end

local function Retarget(inst)
	local notags = {"FX", "NOCLICK","INLIMBO", "ox", "wall"}

	if inst.components.herdmember
	   and inst.components.herdmember:GetHerd()
	   and inst.components.herdmember:GetHerd().components.mood
	   and inst.components.herdmember:GetHerd().components.mood:IsInMood() then
		return FindEntity(inst, TUNING.BEEFALO_TARGET_DIST, function(guy)
			return inst.components.combat:CanTarget(guy)
		end, nil, notags)
	end
end

local function KeepTarget(inst, target)
	
	if inst.components.herdmember
	   and inst.components.herdmember:GetHerd()
	   and inst.components.herdmember:GetHerd().components.mood
	   and inst.components.herdmember:GetHerd().components.mood:IsInMood() then
		local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
		if herd and herd.components.mood and herd.components.mood:IsInMood() then
			return distsq(Vector3(herd.Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < TUNING.BEEFALO_CHASE_DIST*TUNING.BEEFALO_CHASE_DIST
		end
	end

	return true
end

local function OnNewTarget(inst, data)
	if inst.components.follower and data and data.target and data.target == inst.components.follower.leader then
		inst.components.follower:SetLeader(nil)
	end
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30,function(dude)
		return dude:HasTag("ox") and not dude:HasTag("player") and not dude.components.health:IsDead()
	end, 5)
end

local function GetStatus(inst)
	if inst.components.follower.leader ~= nil then
		return "FOLLOWER"
	end
end

local function OnEntityWake(inst)
	return
end

local function OnEntitySleep(inst)
	return
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.sounds = sounds
	inst.walksound = sounds.walk_land
	local shadow = inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	shadow:SetSize( 6, 2 )
	inst.Transform:SetSixFaced()


	MakeCharacterPhysics(inst, 100, .5)
	--MakePoisonableCharacter(inst)
	
	inst:AddTag("ox")
	anim:SetBank("ox")
	anim:SetBuild("ox_build")
	anim:PlayAnimation("idle_loop", true)
	
	inst:AddTag("animal")
	inst:AddTag("largecreature")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.VEGGIE, FOODTYPE.ROUGHAGE }, { FOODTYPE.VEGGIE, FOODTYPE.ROUGHAGE })
    inst.components.eater:SetAbsorptionModifiers(4,1,1)
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "beefalo_body"
	inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE.DEFAULT)
	inst.components.combat:SetRetargetFunction(1, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	 
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('ox')    
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("knownlocations")
	inst:AddComponent("herdmember")
	inst.components.herdmember.herdprefab = "oxherd"

	-- inst:ListenForEvent("entermood", OnEnterMood)
	-- inst:ListenForEvent("leavemood", OnLeaveMood)
	
	inst:AddComponent("leader")
	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
	inst.components.follower.canaccepttarget = false
	inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst:ListenForEvent("attacked", OnAttacked)

	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetPrefab("poop")
	inst.components.periodicspawner:SetRandomTimes(40, 60)
	inst.components.periodicspawner:SetDensityInRange(20, 2)
	inst.components.periodicspawner:SetMinimumSpacing(8)
	inst.components.periodicspawner:Start()

	MakeLargeBurnableCharacter(inst, "swap_fire")
	MakeLargeFreezableCharacter(inst, "beefalo_body")
	
	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.walkspeed = 1.5
	inst.components.locomotor.runspeed = 7
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGox")

	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep
	
	return inst
end

return Prefab( "ox", fn, assets, prefabs) 