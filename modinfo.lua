-- This information tells other players more about the mod
name = "Multi-World DST"
description = "Multi-World Biomes Pack"
author = "Snook-8 and Joachim"
version = "1.2.8"
forumthread = ""
api_version = 10	

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
reign_of_giants_compatible = true

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"environment","worldgen"}

configuration_options =
{
	{
		name = "UseMigrationPortals",
		default = 0,
	},
	{
		name = "UseDefaultLocations",
		default = 1,
	},
}