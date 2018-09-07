function GetModConfigBoolean(key)
	if GetModConfigData(key) == 1 then
		return true
	else
		return false
	end
end

function IsDedicated()
	return GLOBAL.TheNet ~= nil and GLOBAL.TheNet:IsDedicated()
end

function IsSlaveShard()
	return (GLOBAL.TheNet:GetIsServer() or IsDedicated())
end

function HasGorgePort()
	return GLOBAL.KnownModIndex:IsModEnabled("workshop-1429531613")
end

function GetCompatibleGround(tile)
	local mode = 0
	-- local mode = GetModConfigData("TileCompatibility")

	-- Compatibility mode
	if mode == 1 then
		tile = GLOBAL.GROUND_COMPATIBLE_TYPES[tile] or tile
	end

	return GLOBAL.GROUND[tile]
end

function GetGorgePortPrefab(prefab, defaultprefab)
	if HasGorgePort() then
		return prefab
	end
	return defaultprefab
end

function ShallowCopy(tbl)
	local newtbl = {}
	for k,v in pairs(tbl) do
		newtbl[k] = v
	end
	return newtbl
end

GLOBAL.HasGorgePort = HasGorgePort
