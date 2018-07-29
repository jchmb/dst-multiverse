require "behaviours/wander"
require "behaviours/chattynode"
require "behaviours/leash"
require "behaviours/doaction"

local MAX_WANDER_DIST = 15
local LEASH_RETURN_DIST = 5
local LEASH_MAX_DIST = 20
local MAX_PLAYER_DIST = 5
local WAIT_PERIOD = 10
local GIVE_PROBABILITY = 0.1
local HUNGER_THRESHOLD = 0.25

local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("home") or nil
end

local function GetNearestPlayer(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, MAX_PLAYER_DIST, true)
    return #players > 0 and players[1] or nil
end

local function IsPlayerNearby(inst)
	local player = GetNearestPlayer(inst)
	return player ~= nil
end

local function GetFaceTargetFn(inst)
    return GetNearestPlayer(inst)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) < MAX_PLAYER_DIST * MAX_PLAYER_DIST
end

local function GetActionFn(inst)
    local player = GetNearestPlayer(inst)
    if player then
        -- local action = Action()
    end
    return nil
end

local BunsyBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function BunsyBrain:OnStart()
	local root =

	PriorityNode(
	{
        Leash(self.inst, GetHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
        -- IfNode(function() return ShouldSayCraving(self.inst) end, "say craving",
        --     DynamicChat(self.inst, GetCravingChat,
        --         DoTalk(self.inst))),
        -- IfNode(function() return IsPlayerNearby(self.inst) and math.random() <= GIVE_PROBABILITY and GetNearestPlayer(self.inst).components.hunger:GetPercent() <= HUNGER_THRESHOLD end, "Give carrot cake",
        --     ChattyNode(self.inst, "BUNSY_TALK_GIVE_CARROT_CAKE",
        --         DoAction(self.inst, function() GetActionFn(self.inst) end))),
		ChattyNode(self.inst, "BUNSY_TALK_NORMAL",
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),
		-- Leash(self.inst, GetHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
		Wander(self.inst, GetHomePos, MAX_WANDER_DIST)
	}, 0.5)
	self.bt = BT(self.inst, root)
end

return BunsyBrain
