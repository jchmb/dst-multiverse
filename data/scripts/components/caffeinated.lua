local Caffeinated = Class(function(self, inst)
	self.inst = inst
	self.mult = 1
	self.duration = 0
	self.updating = false
end)

function Caffeinated:Caffeinate(mult, duration)
	self.mult = mult
	self.duration = duration
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
		self.updating = true
	end
	self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "caffeinated", self.mult)
end

function Caffeinated:ResetValues()
	self.duration = 0
	self.mult = 1
end

function Caffeinated:WearOff()
	self:ResetValues()
	self.inst:StopUpdatingComponent(self)
	self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "caffeinated")
	self.updating = false
end

function Caffeinated:OnUpdate(dt)
	self.duration = self.duration - dt
	if self.duration <= 0 then
		self:WearOff()
	end
end

function Caffeinated:OnLoad(data)
	if data.mult ~= nil and data.duration ~= nil and data.duration > 0 and data.mult > 1 then
		self:Caffeinate(data.mult, data.duration)
	end
end

function Caffeinated:OnSave()
	return {
		mult = self.mult,
		duration = self.duration,
	}
end

return Caffeinated