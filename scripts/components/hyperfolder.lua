local Hyperfolder = Class(function(self, inst)
	self.inst = inst
	self.startPortalID = nil
	self.startWorldID = nil
	self.endPortalID = nil
	self.endWorldID = nil
end)

function Hyperfolder:OnLoad(data)
	if data.startPortalID ~= nil and data.startWorldID ~= nil then
		self.startPortalID = data.startPortalID
		self.startWorldID = data.startWorldID
	end
	if data.endPortalID ~= nil and data.endWorldID ~= nil then
		self.endPortalID = data.endPortalID
		self.endWorldID = data.endWorldID
	end
end

function Hyperfolder:OnSave()
	return {
		startPortalID = self.startPortalID,
		startWorldID = self.startWorldID,
		endPortalID = self.endPortalID,
		endWorldID = self.endWorldID,
	}	
end

return Hyperfolder
