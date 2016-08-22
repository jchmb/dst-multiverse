require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
--require "behaviours/choptree"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9
local MAX_WANDER_DIST = 20

local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 30

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local START_RUN_DIST = 3
local STOP_RUN_DIST = 30
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local SEE_LIGHT_DIST = 20
local TRADE_DIST = 20
local SEE_TREE_DIST = 15
local SEE_TARGET_DIST = 20
local SEE_FOOD_DIST = 10

local SEE_BURNING_HOME_DIST_SQ = 20*20

local KEEP_CHOPPING_DIST = 10

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local SEE_PLAYER_DIST = 6

local function FindFoodAction(inst)
    local target = nil

    if inst.sg:HasStateTag("busy") then
        return
    end

    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end

    local time_since_eat = inst.components.eater:TimeSinceLastEating()
    local noveggie = time_since_eat and time_since_eat < TUNING.PIG_MIN_POOP_PERIOD*4

    if not target and (not time_since_eat or time_since_eat > TUNING.PIG_MIN_POOP_PERIOD*2) then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item)
                if item:GetTimeAlive() < 8 then return false end
                if item.prefab == "mandrake" then return false end
                if noveggie and item.components.edible and item.components.edible.foodtype ~= FOODTYPE.MEAT then
                    return false
                end
                if not item:IsOnValidGround() then
                    return false
                end
                return inst.components.eater:CanEat(item)
            end)
    end
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end
end

local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("spawnpoint")
end

local GiantBunnymanBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function GiantBunnymanBrain:OnStart()
    --print(self.inst, "PigBrain:OnStart")
    local root = 
        PriorityNode(
        {
            WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            WhileNode(function() return self.inst.components.health:GetPercent() < TUNING.BUNNYMAN_PANIC_THRESH end, "LowHealth", 
                RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST)),
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
            DoAction(self.inst, FindFoodAction),
            Wander(self.inst, GetHomePos, MAX_WANDER_DIST)
        }, 1)

    self.bt = BT(self.inst, root)
end

function GiantBunnymanBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", Point(self.inst.Transform:GetWorldPosition()))
end

return GiantBunnymanBrain
