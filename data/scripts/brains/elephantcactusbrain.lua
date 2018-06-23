require "behaviours/standandattack"
--require "behaviours/faceentity"

local START_FACE_DIST = 10
local KEEP_FACE_DIST = 15

local ElephantCactusBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function ElephantCactusBrain:OnStart()
	local root = PriorityNode(
	{
		WhileNode(function() return self.inst.has_spike end, "Has Spike",
			StandAndAttack(self.inst)),

	}, .25)

	self.bt = BT(self.inst, root)
end

return ElephantCactusBrain
