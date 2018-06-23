local SaltExtractorInstallable = Class(function(self, inst)
    self.inst = inst
    self.extractorprefab = nil
end)

function SaltExtractorInstallable:SetUp(extractorprefab)
    self.extractorprefab = extractorprefab
end

function SaltExtractorInstallable:DoInstall(target)
    local prefab = SpawnPrefab(self.extractorprefab)
    prefab.Transform:SetPosition(target.Transform:GetWorldPosition())
    prefab.components.saltextractor:DoInstall(target)
    return true
end

return SaltExtractorInstallable
