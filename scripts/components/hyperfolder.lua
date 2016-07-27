local Hyperfolder = Class(function(self, inst)
	self.inst = inst
	self.startPortal = nil
	self.endPortal = nil
end)

function Hyperfolder:OnLoad(data)
	return	
end

function Hyperfolder:OnSave()
	return {}	
end

return Hyperfolder
