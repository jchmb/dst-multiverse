local Poisoned = Class(function(self, inst)
	self.inst = inst
	self.dmg = 0
	self.interval = 0
	self.duration = 0
	self.updating = false
	self.lastDamageTime = 0
end)

function Poisoned:SetPoison(dmg, interval, duration)
	self.dmg = dmg
	self.interval = interval
	self.duration = duration
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
	end
end

function Poisoned:ResetValues()
	self.duration = 0
	self.dmg = 0
	self.interval = 0
	self.lastDamageTime = 0
end

function Poisoned:WearOff()
	self:ResetValues()
	self.inst:StopUpdatingComponent(self)
	self.updating = false
end

function Poisoned:OnUpdate(dt)
	self.duration = self.duration - dt
	self.lastDamageTime = self.lastDamageTime - dt
	if self.lastDamageTime <= 0 then
		self.inst.components.health:DoDelta(self.dmg, nil, "poison")
		self.lastDamageTime = self.interval
	end
	if self.duration <= 0 then
		self:WearOff()
	end
end

function Poisoned:OnLoad(data)
	if data.mult ~= 1 and data.duration ~= 0 and data.interval ~= 0 then
		self:SetPoison(data.dmg, data.interval, data.duration)
	end
	if data.lastDamageTime ~= nil then
		self.lastDamageTime = lastDamageTime
	end
end

function Poisoned:OnSave()
	return {
		dmg = self.dmg,
		interval = self.interval,
		duration = self.duration,
		lastDamageTime = self.lastDamageTimel
	}
end

return Poisoned