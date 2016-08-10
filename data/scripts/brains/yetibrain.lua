require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/minperiod"
require "giantutils"

local SEE_DIST = 40

local CHASE_DIST = 32
local CHASE_TIME = 20

local function GetWanderPos(inst)
    return inst.components.knownlocations:GetLocation("herd")
end

local YetiBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function YetiBrain:OnStart()
    local root =
        PriorityNode(
        {
            AttackWall(self.inst),
            ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
            Wander(self.inst, GetWanderPos, 30, {minwwwalktime = 10}),
        },1)
    
    self.bt = BT(self.inst, root)
end

function YetiBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", Point(self.inst.Transform:GetWorldPosition()))
end

return YetiBrain
