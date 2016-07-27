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

function Hyperfolder:RegisterStartPortal(portal)
	self.startWorldID = TheShard:GetID() -- TMP / TODO check if this is actually the right function
	self.startPortalID = portal.id
end

function Hyperfolder:RegisterEndPortal(portal)
	self.endWorldID = TheShard:GetID() -- TMP / TODO check if this is actually the right function
	self.endPortalID = portal.id
	portal.components.worldmigrator:SetReceivedPortal(self.startWorldID, self.startPortalID)
end

function Hyperfolder:DoReturn(portal, doer)
	self.returning = true
	portal.components.worldmigrator:Activate(doer)
end

function Hyperfolder:FindStartPortal()
	if self.startPortalID ~= nil and self.startWorldID ~= nil then
		for k,v in pairs(Ents) do
			if v.components.worldmigrator ~= nil and v.components.worldmigrator.id == self.startPortalID then
				return v	
			end
		end
		return nil
	else
		self:Clear()
		return nil
	end
end

function Hyperfolder:OnReturn()
	portal = self:FindStartPortal()
	portal.components.worldmigrator:SetReceivedPortal(self.startWorldID, self.startPortalID)
	self:Clear()
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
