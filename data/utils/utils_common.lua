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
