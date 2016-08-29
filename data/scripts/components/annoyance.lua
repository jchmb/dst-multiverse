local Annoyance = Class(function(self, inst)
	self.inst = inst
	self.value = 0
	self.cooloff = nil
	self.cooloff_interval = 10
	self.threshold = 10
	self.updating = false
end)

function Annoyance:CoolOff()
	self.updating = false
	self.value = 0
	self.inst:StopUpdatingComponent(self)
	self.cooloff = nil
end

function Annoyance:IsAnnoyed()
	return self.value >= self.threshold
end

function Annoyance:Annoy(value)
	value = value or 1
	self.value = self.value + value
	if self.value >= self.cooloff_interval and not self.updating then
		self.inst:StartUpdatingComponent(self)
		self.updating = true
		self.cooloff = self.cooloff_interval
	end
end

function Annoyance:SetCooloffInterval(interval)
	self.cooloff_interval = interval
end

function Annoyance:SetThreshold(threshold)
	self.threshold = threshold
end

function Annoyance:OnUpdate(dt)
	if self.cooloff ~= nil then
		self.cooloff = self.cooloff - dt
		if self.cooloff <= 0 then
			self:CoolOff()
		end
	else
		self.updating = false
	end
end

return Annoyance