local Tapper = Class(function(self, inst)
    self.inst = inst
    self.value = 0
    self.onthresholdfn = nil
    self.items = {}
end)

function Tapper:OnThresholdFn(onthresholdfn)
    self.onthresholdfn = onthresholdfn
end

function Tapper:Empty()
    self.items = {}
    self.value = 0
end

function Tapper:AddItem(item)
    table.insert(self.items, item)
end

function Tapper:GiveHarvest(doer)
    for i,v in ipairs(self.items) do
        local item = SpawnPrefab(v)
        doer.components.inventory:GiveItem(item)
    end
end

function Tapper:Tap(value)
    self.value = self.value + value
    if self.value >= 1 then
        self.value = 0
        self.onthresholdfn(self.inst)
        return true
    end
    return false
end

return Tapper
