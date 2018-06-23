local SaltPond = Class(function(self, inst)
    self.inst = inst
    self.numsalt = 0
    self.maxsalt = 0
    self.saltprefab = nil
    self.saltextractor = nil
    -- self.basetime = 150
    self.basetime = 5
    -- self.timeinc = 10
    self.timeinc = 1
end)

function SaltPond:SetUp(saltprefab, numsalt)
    self.saltprefab = saltprefab
    self.numsalt = numsalt
    self.maxsalt = numsalt
end

function SaltPond:Install(saltextractor)
    self.saltextractor = saltextractor
end

return SaltPond
