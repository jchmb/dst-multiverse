-- This information tells other players more about the mod
name = "Multi-World DST"
description = "Multi-World Biomes Pack"
author = "Snook-8 and Joachim"
version = "1.7.17"
forumthread = ""
api_version = 10

-- This guarantees that it will be loaded after some (optional) character mods
priority = -1

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
reign_of_giants_compatible = true

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"environment","worldgen"}

configuration_options =
{
	-- It is recommended to enable this on dedicated servers.
	{
		name = "UseMigrationPortals",
		default = 0,
	},
	{
		name = "UseDefaultLocations",
		default = 1,
	},

	-- Whether to enable starting items (e.g., seasonal and a number of basic resources after a certain number of days)
	{
		name = "EnableStartingItems",
		description = "Enable starting items",
		default = 0,
		options = {
			{
				description = "Yes",
				data = 1,
			},
			{
				description = "No",
				data = 0,
			},
		},
	},

	-- In case you want named migration portals, you can assign worldnames to shard IDs here.
	{
		name = "WorldNames",
		default = {}
	},

	-- Whether to connect migration portals.
	{
		name = "UseMultiShards",
		default = false,
	},

	-- Delete unused migration portals.
	{
		name = "DeleteUnused",
		description = "Mod will delete unused portals instead just plugging them",
		default = true
	},

	-- The connections used for connecting shards (if UseMultiShards is enabled)
	{
		name = "Connections",
		default = {
			["1"] = { "11", "12" }, -- Shard 1 connected to shard 11 and shard 12
			["11"] = { "12" } -- Shard 11 connected to shard 12
			-- only connect one way (bidirection is done by the mod)
		},
	},
	{
		name = "MultiConnections",
		default = {},
	},
}
