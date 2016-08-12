local Poisonable = Class(function(self, inst)
	self.inst = inst
	self.dmg = 0
	self.interval = 0
	self.maxInterval = 5
	self.minInterval = 1
	self.defaultDuration = 60 * 16
	self.startDuration = 0
	self.duration = 0
	self.updating = false
	self.lastDamageTime = 0
end)

function Poisonable:SetPoison(dmg, interval, duration)
	self.dmg = dmg or 1
	self.interval = interval or self.maxInterval
	self.startDuration = duration or self.defaultDuration
	self.duration = self.startDuration
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
	end
end

function Poisonable:ResetValues()
	self.duration = 0
	self.startDuration = 0
	self.dmg = 0
	self.interval = 0
	self.lastDamageTime = 0
end

function Poisonable:WearOff()
	self:ResetValues()
	self.inst:StopUpdatingComponent(self)
	self.updating = false
end

function Poisonable:IncreaseIntensity()
	if self.duration ~= 0 and self.interval > self.minInterval then
		local progress = self.maxDuration / self.duration
		self.interval = math.max(progress * self.maxInterval, self.minInterval)
	end
end

function Poisonable:OnUpdate(dt)
	self.duration = self.duration - dt
	self.lastDamageTime = self.lastDamageTime - dt
	if self.lastDamageTime <= 0 then
		self.inst.components.health:DoDelta(self.dmg, nil, "poison")
		self:IncreaseIntensity()
		self.lastDamageTime = self.interval
	end
	if self.duration <= 0 then
		self:WearOff()
	end
end

function Poisonable:OnLoad(data)
	if data.mult ~= 1 and data.startDuration ~= 0 and data.duration ~= 0 and data.interval ~= 0 then
		self:SetPoison(data.dmg, data.interval, data.duration)
		self.startDuration = data.startDuration
	end
	if data.lastDamageTime ~= nil then
		self.lastDamageTime = lastDamageTime
	end
end

function Poisonable:OnSave()
	return {
		dmg = self.dmg,
		interval = self.interval,
		duration = self.duration,
		startDuration = self.startDuration,
		lastDamageTime = self.lastDamageTime
	}
end

return Poisonable
