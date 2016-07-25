GLOBAL.global("jchmb")
GLOBAL.jchmb = {}

GLOBAL.jchmb.IsInstanceOf = function(obj, cls)
	return (obj.prefab ~= nil and obj.prefab == cls) or
		(obj.name ~= nil and obj.name == cls)
end

GLOBAL.jchmb.IsOneOf = function(obj, classes)
	for i,cls in ipairs(classes) do
		if GLOBAL.jchmb.IsInstanceOf(obj, cls) then
			return true
		end
	end
	return false
end

GLOBAL.jchmb.SpawnPrefabAtOwner = function(owner, prefab)
	SpawnPrefab(prefab).Transform:SetPosition(owner.Transform:GetWorldPosition())
end