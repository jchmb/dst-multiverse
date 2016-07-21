local Caffeinated = Class(function(self, inst)
	self.inst = inst
	self.mult = 1
	self.intaketime = nil
	self.duration = 0
end)

function Caffeinated:Caffeinate(mult, duration)
	self.mult = mult
	self.intaketime = GetTime()
	self.duration = duration
	self.inst:StartUpdatingComponent(self)
end

function Caffeinated:OnUpdate(dt)
	local time = GetTime()
	if time >= intaketime + duration then
		self.inst:StopUpdatingComponent(self)
		self:ResetValues()
	end
end

function Caffeinated:ResetValues()
	self.intaketime = nil
	self.duration = 0
	self.mult = 1
end