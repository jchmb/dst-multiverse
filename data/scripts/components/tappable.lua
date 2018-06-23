local Tappable = Class(function(self, inst)
	self.inst = inst
    self.tapper = nil
    self.oninstallfn = nil
    self.onuninstallfn = nil
end)

function Tappable:SetOnInstallFn(oninstallfn)
    self.oninstallfn = oninstallfn
end

function Tappable:SetOnUninstallFn(onuninstallfn)
    self.onuninstallfn = onuninstallfn
end

function Tappable:IsTapped()
    return self.tapper ~= nil
end

function Tappable:InstallTap(doer, item)
    self.tapper = item
    if self.oninstallfn then
        self.oninstallfn(self.inst)
    end
	self.inst:AddTag("tapped_harvestable")
	self.inst:RemoveTag("tappable")
	if doer ~= nil then
		doer.components.inventory:RemoveItem(item)
	end
end

function Tappable:UninstallTap(doer, drop)
	local tapper = self.tapper
    self.tapper = nil
	self.inst:RemoveTag("tapped_harvestable")
	self.inst:AddTag("tappable")
	if self.inst.components.harvestable and self.inst.components.harvestable:CanBeHarvested() then
		self.inst.components.harvestable:Harvest(not drop and doer or nil)
	end
	local sapbucket = SpawnPrefab("sapbucket")
	if not drop then
		doer.components.inventory:GiveItem(sapbucket)
	else
		sapbucket.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		sapbucket.components.inventoryitem:OnDropped(doer.Transform:GetWorldPosition() - self.inst.Transform:GetWorldPosition())
	end
	if self.onuninstallfn then
        self.onuninstallfn(self.inst)
    end
end

return Tappable
