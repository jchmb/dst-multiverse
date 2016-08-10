--[[
	Shard Utilities
	This will attempt to uniformly distirbute connections evenly for all shards, rather than
	having to set the connections manually.
--]]

local function InitLinkCountTable(shardIds)
	local counts = {}
	for i,shardId in ipairs(shardIds) do
		counts[shardId] = 0
	end
	return counts
end

local function InitConnections(shardIds)
	local connections = {}
	for i,shardId in ipairs(shardIds) do
		connections[shardId] = {}
	end
	return connections
end

local function GetRemainingShards(shardIds, shardId, counts, numPortals)
	local remainingShards = {}
	for i,v in ipairs(shardIds) do
		if v ~= shardId and counts[v] < numPortals then
			table.insert(remainingShards, v)
		end
	end
	return remainingShards
end

local function GenerateConnection(shardX, shardY, counts, connections)
	table.insert(connections[shardX], shardY)
	counts[shardX] = counts[shardX] + 1
	counts[shardY] = counts[shardY] + 1
end

local function GetAvailableShard(shardIds, counts, k)
	for i,v in ipairs(shardIds) do

	end
end

function GenerateConnections(shardIds, numPortals)
	numPortals = numPortals or 10
	local counts = InitLinkCountTable(shardIds)
	local connections = InitConnections(shardIds)
	local k = 1
	for i,shardX in ipairs(shardIds) do
		local n = numPortals - counts[shardX]
		if n > 0 then
			for j=1,n do
				local shardY = remaining[k]
				GenerateConnection(shardX, shardY, counts, connections)
			end
		end
	end
end
