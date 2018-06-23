local SaltExtractor = Class(function(self, inst)
    self.inst = inst
    self.pond = nil
    self.onharvestfn = nil
    self.onextractfn = nil
end)

function SaltExtractor:SetUp(onharvestfn, onextractfn)
    self.onextractfn = onextractfn
    self.onharvestfn = onharvestfn
end

function SaltExtractor:UpdateExtractTime()
    if self.pond then
        local saltpond = self.pond.components.saltpond
        saltpond.growtime = saltpond.basetime + saltpond.timeinc * (saltpond.maxsalt - saltpond.numsalt)
    end
end

local function OnHarvest(inst, picker, produce)
    inst.components.saltextractor.onharvestfn(inst, picker, produce)
end

local function OnExtract(inst, produce)
    if produce > 0 then
        inst.components.saltextractor:UpdateExtractTime()
    end
    inst.components.saltextractor.onextractfn(inst, produce)
end

function SaltExtractor:DoInstall(target)
    self.pond = target
    target.components.saltpond:Install(self.inst)

    local saltpond = target.components.saltpond

    self.inst:AddComponent("harvestable")
    self.inst.components.harvestable:SetUp(
        saltpond.saltprefab,
        1,
        saltpond.basetime + saltpond.timeinc * (saltpond.maxsalt - saltpond.numsalt),
        OnHarvest,
        OnExtract
    )
end

return SaltExtractor
