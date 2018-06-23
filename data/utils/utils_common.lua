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

function GetCompatibleGround(tile)
	local mode = 0
	-- local mode = GetModConfigData("TileCompatibility")

	-- Compatibility mode
	if mode == 1 then
		tile = GLOBAL.GROUND_COMPATIBLE_TYPES[tile] or tile
	end

	return GLOBAL.GROUND[tile]
end
