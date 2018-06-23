require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"


local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 12
local TARGET_FOLLOW_DIST = 6

local MAX_WANDER_DIST = 3

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 40

local function GetFaceTargetFn(inst)
	return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
	return inst.components.follower.leader == target
end


local PackimBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)


function PackimBrain:OnStart()
	local root =
	PriorityNode({
		WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		WhileNode(function() return self.inst.PackimState == "FIRE" and self.inst.components.combat.target ~= nil and self.inst.components.combat.target ~= GetPlayer() end, "Attack",
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
		WhileNode( function() return self.inst.PackimState == "FIRE" and (self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown()) end, "AttackMomentarily",
			ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),

	}, .25)
	self.bt = BT(self.inst, root)
end

return PackimBrain
