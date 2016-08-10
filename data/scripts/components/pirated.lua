local Pirated = Class(function(self, inst)
	self.inst = inst
	self.numPirates = function(numPlayers)
		if numPlayers == 0 then
			return 0
		elseif numPlayers == 1 then
			return 3	
		elseif numPlayers == 2 then
			return 5
		else
			return 5 + (numPlayers - 2)	
		end
	end
	self.numItems = 5
end

local SPAWN_DIST = 50
local GROUP_DIST = 20
local CONTAINER_DIST = 20

local function GetSpawnPoint(pt)
	local theta = math.random() * 2 * PI
	local offset = FindWalkableOffset(target, theta, SPAWN_DIST, 20, true)
	if offset then
		return pt + offset 	
	end
end

local function SpawnPirate(target, numItems)
	local pt = Vector3(target.Transform:GetWorldPosition())
	local spawn_pt = GetSpawnPoint(pt)
	if spawn_pt then
		local pirate = SpawnPrefab("piratebunnyman")
		pirate.numitems = numItems -- Number of items to steal
		pirate.piratetarget = target
		pirate.Physics:Teleport(spaw_pt:Get())
		pirate:FacePoint(pt)
	end
end

local function ReleasePiratesForTarget(self, target, count)
	for i=1,count do
		SpawnPirate(target, self.numItems)
	end
end

local function GetCloseGroup(player, groups)
	for i,g	in ipairs(groups) do
		for j,p in ipairs(g) do
			if p:IsNear(player, GROUP_DIST) then
				return g	
			end
		end
	end
end

local function MakeGroups()
	local groups = {}
	for i,player in ipairs(AllPlayers) do
		local closeGroup = GetCloseGroup(player, groups)
		if #groups == 0 or closeGroup == nil then
			local group = {}
			table.insert(groups, group)
			table.insert(group, player)
		else
			table.insert(closeGroup, player)
		end
	end
	return groups
end

local function IsValuableItem(item)
	return item.prefab == "goldnugget" or (item.components.edible and item.components.edible.foodtype == FOODTYPE.VEGGIE)
end

local function GetTargetForPlayer(player)
	local container = FindEntity(player, CONTAINER_DIST, function(x)
		return x.components.container and x.components.container:FindItem(IsValuableItem)
	end)
	if container ~= nil then
		return container	
	end
	local flooritem = FindEntity(player, CONTAINER_DIST, IsValuableItem)
	if flooritem ~= nil then
		return flooritem	
	end
	if player.components.inventory and player.components.inventory:FindItem(IsValuableItem) then
		return player
	end
end

function Pirated:ReleasePirates()
	local groups = MakeGroups()
	for i,g in ipairs(groups) do
		for j=1,self.numPirates() do
			local player = g[j % #self.numPirates]
			local target = GetTargetForPlayer(player)
			if target ~= nil then
				SpawnPirate(target, self.numItems)
			end
		end
	end
end

return Pirated
