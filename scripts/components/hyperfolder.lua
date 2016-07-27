local Hyperfolder = Class(function(self, inst)
	self.inst = inst
	self.startPortalID = nil
	self.startWorldID = nil
	self.endPortalID = nil
	self.endWorldID = nil
	self.returning = false
end)

function Hyperfolder:Clear()
	self.startPortalID = nil
	self.startWorldID = nil
	self.endPortalID = nil
	self.endWorldID = nil
	self.returning = false
end

function Hyperfolder:OnLoad(data)
	if data.startPortalID ~= nil and data.startWorldID ~= nil then
		self.startPortalID = data.startPortalID
		self.startWorldID = data.startWorldID
	end
	if data.endPortalID ~= nil and data.endWorldID ~= nil then
		self.endPortalID = data.endPortalID
		self.endWorldID = data.endWorldID
	end
	if data.returning ~= nil then
		self.returning = data.returning
	end
end

function Hyperfolder:OnSave()
	return {
		startPortalID = self.startPortalID,
		startWorldID = self.startWorldID,
		endPortalID = self.endPortalID,
		endWorldID = self.endWorldID,
		returning = self.returning,
	}	
end

return Hyperfolder
