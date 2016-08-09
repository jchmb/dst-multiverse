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

local START_RUN_DIST = 3
local STOP_RUN_DIST = 5
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local SEE_LIGHT_DIST = 20
local TRADE_DIST = 20
local SEE_TREE_DIST = 15
local SEE_TARGET_DIST = 20
local SEE_FOOD_DIST = 10

local SEE_BURNING_HOME_DIST_SQ = 20*20

local COMFORT_LIGHT_LEVEL = 0.3

local KEEP_CHOPPING_DIST = 10

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8

local function ShouldRunAway(inst, target)
    return not inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetTraderFn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, TRADE_DIST, true)
    for i, v in ipairs(players) do
        if inst.components.trader:IsTryingToTradeWithMe(v) then
            return v
        end
    end
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function IsWood(inst, item)
    return item.components.edible and item.components.edible:GetWoodiness(item) > 0
end

local function HasWood(inst)
    return inst.components.inventory and
        inst.components.inventory:FindItem(function(x) return IsWood(inst, x) end)
end

local function WoodIsNear(inst)
    if HasWood(inst) then
        return true
    end
    return FindEntity(inst, SEE_FOOD_DIST, function(x) return IsWood(inst, x) end)
end

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
                if IsWood(inst, item) then
                    return true
                end
                if item:GetTimeAlive() < 8 then return false end
                if item.prefab == "mandrake" then return false end
                if noveggie and item.components.edible and item.components.edible.foodtype ~= FOODTYPE.WOOD then
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

    if not target and (not time_since_eat or time_since_eat > TUNING.PIG_MIN_POOP_PERIOD*2) then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) 
                if not item.components.shelf then return false end
                if not item.components.shelf.itemonshelf or not item.components.shelf.cantakeitem then return false end
                if noveggie and item.components.shelf.itemonshelf.components.edible and item.components.shelf.itemonshelf.components.edible.foodtype ~= FOODTYPE.MEAT then
                    return false
                end
                if not item:IsOnValidGround() then
                    return false
                end
                return inst.components.eater:CanEat(item.components.shelf.itemonshelf) 
            end)
    end

    if target then
        return BufferedAction(inst, target, ACTIONS.TAKEITEM)
    end
end

local function IsDeciduousTreeMonster(guy)
    return guy.monster and guy.prefab == "deciduoustree"
end

local function FindDeciduousTreeMonster(inst)
    return FindEntity(inst, SEE_TREE_DIST / 3, IsDeciduousTreeMonster, { "CHOP_workable" })
end

local function KeepChoppingAction(inst)
    return inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, KEEP_CHOPPING_DIST))
        or FindDeciduousTreeMonster(inst) ~= nil
end

local function StartChoppingCondition(inst)
    return inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("chopping"))
        or FindDeciduousTreeMonster(inst) ~= nil
end

local function FindTreeToChopAction(inst)
    local target = FindEntity(inst, SEE_TREE_DIST, nil, { "CHOP_workable" })
    if target ~= nil then
        if inst.tree_target ~= nil then
            target = inst.tree_target
            inst.tree_target = nil
        else
            target = FindDeciduousTreeMonster(inst) or target
        end
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

local function HasValidHome(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and not (home.components.burnable ~= nil and home.components.burnable:IsBurning())
        and not home:HasTag("burnt")
end

local function GoHomeAction(inst)
    if not inst.components.follower.leader and
        HasValidHome(inst) and
        not inst.components.combat.target then
            return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetLeader(inst)
    return inst.components.follower.leader
end

local function GetHomePos(inst)
    return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function GetNoLeaderHomePos(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetHomePos(inst)
end

local function GetNearestLightPos(inst)
    local light = GetClosestInstWithTag("lightsource", inst, SEE_LIGHT_DIST)
    if light then
        return Vector3(light.Transform:GetWorldPosition())
    end
    return nil
end

local function GetNearestLightRadius(inst)
    local light = GetClosestInstWithTag("lightsource", inst, SEE_LIGHT_DIST)
    if light then
        return light.Light:GetCalculatedRadius()
    end
    return 1
end

local function RescueLeaderAction(inst)
    return BufferedAction(inst, GetLeader(inst), ACTIONS.UNPIN)
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function SafeLightDist(inst, target)
    return (target:HasTag("player") or target:HasTag("playerlight")
            or (target.inventoryitem and target.inventoryitem:GetGrandOwner() and target.inventoryitem:GetGrandOwner():HasTag("player")))
        and 4
        or target.Light:GetCalculatedRadius() / 3
end

local function IsHomeOnFire(inst)
    return inst.components.homeseeker
        and inst.components.homeseeker.home
        and inst.components.homeseeker.home.components.burnable
        and inst.components.homeseeker.home.components.burnable:IsBurning()
        and inst:GetDistanceSqToInst(inst.components.homeseeker.home) < SEE_BURNING_HOME_DIST_SQ
end

local WildbeaverBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function WildbeaverBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted",
                Panic(self.inst)),
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
                Panic(self.inst)),
            ChattyNode(self.inst, "WILDBEAVER_TALK_FIGHT",
                WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
                    ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST) )),
            WhileNode( function() return GetLeader(self.inst) and GetLeader(self.inst).components.pinnable and GetLeader(self.inst).components.pinnable:IsStuck() end, "Leader Phlegmed",
                    DoAction(self.inst, RescueLeaderAction, "Rescue Leader", true) ),
            WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
                    RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) ),
            WhileNode(function() return IsHomeOnFire(self.inst) end, "OnFire",
                Panic(self.inst)),
            FaceEntity(self.inst, GetTraderFn, KeepTraderFn),
            DoAction(self.inst, FindFoodAction ),
            IfNode(function() return StartChoppingCondition(self.inst) end, "chop", 
                WhileNode(function() return KeepChoppingAction(self.inst) end, "keep chopping",
                    LoopNode{ 
                        DoAction(self.inst, FindTreeToChopAction )})),
            ChattyNode(self.inst, "WILDBEAVER_TALK_FOLLOW",
                Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),
            WhileNode(function() return not TheWorld.state.iscaveday end, "IsNight",
                    ChattyNode(self.inst, "WILDBEAVER_TALK_GOHOME", DoAction(self.inst, GoHomeAction, "go home", true ), 1)),
            IfNode(function() return self.inst.WantsToChop(self.inst) and not WoodIsNear(self.inst) end, "wants to chop", 
                WhileNode(function() return self.inst.WantsToChop(self.inst) and not WoodIsNear(self.inst) end, "keep chopping",
                    LoopNode{ 
                        DoAction(self.inst, FindTreeToChopAction )})),
            Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
            Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST),
        }, .5)

    self.bt = BT(self.inst, root)
end

return WildbeaverBrain
