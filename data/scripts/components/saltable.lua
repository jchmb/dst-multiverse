local Saltable = Class(function(self, inst)
    self.inst = inst
    self.saltlevel = 0
end)

function Saltable:SetUp()
    local stackable = self.inst.components.stackable
end

function Saltable:AddSalt()
    self.saltlevel = self.saltlevel + 1
end

function Saltable:IsSalted()
    return self.saltlevel > 0
end

function Saltable:CanSalt()
    return self.saltlevel == 0
end

return Saltable
