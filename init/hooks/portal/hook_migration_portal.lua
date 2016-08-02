local ALL_CONNECTIONS = GetModConfigData("MultiConnections")
local DELETE_UNUSED = GetModConfigData("DeleteUnused")
local WORLD_NAMES = GetModConfigData("WorldNames")

local VALID_WORLD_NAMES = {
	"cute", "chezz", "slimey", "gray", "snowy"
}

local function IsValidMultiWorld(wn)
	for i,v in ipairs(VALID_WORLD_NAMES) do
		if v == wn then
			return true
		end
	end
	return false
end

local function ReplacePortalNames(prefab, linkedWorldID)
	local worldName = WORLD_NAMES[linkedWorldID]
	if worldName ~= nil then
		prefab:AddComponent("named")
		prefab.components.named:SetName(STRINGS.NAMES[string.upper("multiworld_" .. worldName)])

		-- Need a proper check here
		if IsValidMultiWorld(worldName) then
			prefab.MiniMapEntity:SetIcon("minimap_portal_" .. worldName .. ".tex")
		end
	else
		prefab:AddComponent("named")
		prefab.components.named:SetName("Unknown World")
	end
end
	
HookInitConnect = function(prefab)
	local shardId = GLOBAL.TheShard:GetShardId()
	local portalId = prefab.components.worldmigrator.id
		
	prefab.components.worldmigrator.linkedWorld = -1
	prefab.components.worldmigrator.auto = false
		
	local nextFreePortal = {}
	for from, toTable in pairs(ALL_CONNECTIONS) do
		nextFreePortal[from] = nextFreePortal[from] or 1
		
		for id, to in pairs(toTable) do
			nextFreePortal[to] = nextFreePortal[to] or 1
			
			local fromPortal = nextFreePortal[from]
			local toPortal = nextFreePortal[to]
				
			if ((from == shardId) or (to == shardId)) then
				if (nextFreePortal[shardId] == portalId) then
					local linkedShardID = (from == shardId) and to or from
					prefab.components.worldmigrator.linkedWorld = linkedShardID
					prefab.components.worldmigrator.receivedPortal = (from == shardId) and toPortal or fromPortal
					prefab.components.worldmigrator:ValidateAndPushEvents()
					
					ReplacePortalNames(prefab, linkedShardID)
						
					return
				end
			end
				
			nextFreePortal[from] = nextFreePortal[from] + 1
			nextFreePortal[to] = nextFreePortal[to] + 1
		end
	end

	if DELETE_UNUSED then
		prefab:Remove()
	else
		prefab.components.worldmigrator:SetEnabled(false)
	end
end