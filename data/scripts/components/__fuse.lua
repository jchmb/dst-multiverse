local Fuse = Class(function(self, inst)
	self.inst = inst

	self.fusetime = 5
	self.maxfusetime = 5
	self.consuming = false
	self.period = 1
	self.onfusedone = nil
end)

function Fuse:SetFuseTime(time)
	self.maxfusetime = time
	self.fusetime = time
end

function Fuse:StartFuse()
	self.consuming = true
	self.inst:PushEvent("fusestart", {time = self.fusetime})
	if not self.task then
		self.task = self.inst:DoPeriodicTask(self.period, function() self:DoUpdate(self.period) end)
	end
end

function Fuse:StopFuse()
	self.consuming = false
	self.inst:PushEvent("fusestop", {time = self.fusetime})
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
end

function Fuse:DoDelta(delta)
	self.fusetime = self.fusetime + delta
	self.fusetime = math.clamp(self.fusetime, 0, self.maxfusetime)
	self.inst:PushEvent("fusedelta", {time = self.fusetime})
end

function Fuse:FuseDone()
	if self.onfusedone then
		self.onfusedone(self.inst)
	end
	self:StopFuse()
end

function Fuse:DoUpdate(dt)
	self:DoDelta(-dt)

	if self.fusetime <= 0 then
		self:FuseDone()
	end
end

function Fuse:OnSave()
	local data = {}
	data.fusetime = self.fusetime
	data.consuming = self.consuming
	return data
end

function Fuse:OnLoad(data)
	if data then
		self.fusetime = data.fusetime
		if data.consuming then
			self:StartFuse()
		end
	end
end

return Fuse
