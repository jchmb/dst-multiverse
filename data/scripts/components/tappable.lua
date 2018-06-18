local Tappable = Class(function(self, inst)
	self.inst = inst
    self.tapper = nil
    self.interval = 5
    self.task = nil
    self.oninstallfn = nil
    self.onuninstallfn = nil
    self.prefab = nil
end)

function Tappable:SetPrefab(prefab)
    self.prefab = prefab
end

function Tappable:SetOnInstallFn(oninstallfn)
    self.oninstallfn = oninstallfn
end

function Tappable:SetOnUninstallFn(onuninstallfn)
    self.onuninstallfn = onuninstallfn
end

function Tappable:StartTapping()
    self.task = self.inst:DoPeriodicTask(self.interval, function()
        if self.tapper.components.tapper:Tap(0.01) then
            self.tapper.components.tapper:AddItem(self.prefab)
        end
    end)
end

function Tappable:StopTapping()
    if self.task then
        self.task:Cancel()
    end
    self.task = nil
end

function Tappable:IsTapped()
    return self.tapper ~= nil
end

function Tappable:InstallTap(doer, item)
    self.tapper = item
    if self.oninstallfn then
        self.oninstallfn(self.inst)
    end
    self:StartTapping()
end

function Tappable:UninstallTap(doer)
    if self.onuninstallfn then
        self.onuninstallfn(self.inst)
    end
    self:StopTapping()
    doer.components.inventory:GiveItem(self.tapper)
    self.tapper.components.tapper:GiveHarvest(doer)
    self.tapper.components.tapper:Empty()
    self.tapper = nil
end

return Tappable
