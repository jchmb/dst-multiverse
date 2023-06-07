-- local AddBackwardsCompatibleTile(id, numeric_id, name, data, )

-- BEACH = {
-- 	tile_range = TileRanges.LAND,
-- 	tile_data = {
-- 		ground_name = "Beach",
-- 		old_static_id = 90,
-- 	},
-- 	ground_tile_def  = {
-- 		name = "beach",
-- 		noise_texture = "ground_noise_sand",
-- 		runsound = "dontstarve/movement/ia_run_sand",
-- 		walksound = "dontstarve/movement/ia_walk_sand",
-- 		flashpoint_modifier = 0,
-- 		bank_build = "turf_ia",
-- 		cannotbedug = true,
-- 	},
-- 	minimap_tile_def = {
-- 		name = "map_edge",
-- 		noise_texture = "mini_beach_noise",
-- 	},
-- 	--turf_def = {
-- 	--    name = "beach",
-- 	--    bank_build = "turf_ia",
-- 	--},
-- },

-- function(tile_name, tile_range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
local function AddBackwardsCompatibleTile(id, numeric_id, name, data, minimap_data)
	-- local tile = {
	-- 	runsound = data.runsound,
	-- 	walksound = data.walksound,
	-- 	snowsound = data.snowsound,
	-- 	mudsound = data.mudsound,
	-- 	minimap_noise_texture = minimap_data.noise_texture,
	-- 	turf_name = "turf_" .. name,
	-- }
	-- data.minimap_noise_texture = minimap_data.noise_texture
	local tile_data = {
		ground_name = name,
	}
	local ground_tile_def = {
		name = name,
		noise_texture = data.noise_texture,
		runsound	 = data.runsound,
		walksound = data.walksound,
		snowsound = data.snowsound,
		mudsound = data.mudsound,
		flashpoint_modifier = data.flashpoint_modifier,
		bank_build = data.bank_build,
	}
	local minimap_tile_def = {
		name = name,
		noise_texture = minimap_data.noise_texture,
	}
	-- local turf_def = {
	-- 	name = name,
	-- 	bank_build = "turf_grass",
	-- }
	AddTile(id, "LAND", tile_data, ground_tile_def, minimap_tile_def, nil)
end

AddBackwardsCompatibleTile(
	"SNOWY",
	80,
	"snowy",
	{
		noise_texture = "levels/textures/noise_snowy.tex",
		runsound = "dontstarve/movement/run_snow",
		walksound = "dontstarve/movement/run_snow",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_snowy.tex"}
)

AddBackwardsCompatibleTile(
	"SLIMEY",
	50,
	"slimey",
	{
		noise_texture = "levels/textures/noise_slimey.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_slimey.tex"}
)

AddBackwardsCompatibleTile(
	"ICE_LAKE",
	51,
	"ice_lake",
	{
		noise_texture = "levels/textures/noise_ice_lake.tex",
		runsound = "dontstarve/movement/run_ice",
		walksound = "dontstarve/movement/run_ice",
		snowsound = "dontstarve/movement/run_ice",
		mudsound = "dontstarve/movement/run_ice",
	},
	{noise_texture = "levels/textures/mini_noise_ice_lake.tex"}
)

AddBackwardsCompatibleTile(
	"GRASS_GRAY",
	52,
	"grass_gray",
	{
		noise_texture = "levels/textures/noise_grass_gray.tex",
		runsound = "dontstarve/movement/run_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_grass_gray.tex"}
)

AddBackwardsCompatibleTile(
	"ASH",
	53,
	"ash",
	{
		noise_texture = "levels/textures/noise_ash.tex",
		runsound = "dontstarve/movement/run_dirt",
		walksound = "dontstarve/movement/walk_dirt",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_ash.tex"}
)

AddBackwardsCompatibleTile(
	"VOLCANO",
	54,
	"volcano",
	{
		noise_texture = "levels/textures/noise_volcano.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_volcano.tex"}
)

AddBackwardsCompatibleTile(
	"MAGMA",
	55,
	"magma",
	{
		noise_texture = "levels/textures/noise_magma.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_magma.tex"}
)

AddBackwardsCompatibleTile(
	"LAVA_ROCK",
	56,
	"lava_rock",
	{
		noise_texture = "levels/textures/noise_lava_rock.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_lava_rock.tex"}
)

AddBackwardsCompatibleTile(
	"GRASS_BLUE",
	57,
	"grass_blue",
	{
		noise_texture = "levels/textures/noise_grass_blue.tex",
		runsound = "dontstarve/movement/run_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_grass_blue.tex"}
)

AddBackwardsCompatibleTile(
	"SAND",
	58,
	"sand",
	{
		noise_texture = "levels/textures/noise_sand.tex",
		runsound = "dontstarve/movement/run_dirt",
		walksound = "dontstarve/movement/walk_dirt",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_sand.tex"}
)

AddBackwardsCompatibleTile(
	"JUNGLE",
	59,
	"jungle",
	{
		noise_texture = "levels/textures/noise_jungle.tex",
		runsound = "dontstarve/movement/run_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_jungle.tex"}
)

AddBackwardsCompatibleTile(
	"GRASS_CHESS",
	60,
	"grass_chess",
	{
		noise_texture = "levels/textures/noise_grass_chess.tex",
		runsound = "dontstarve/movement/run_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_grass_chess.tex"}
)

AddBackwardsCompatibleTile(
	"GRASS_BROWN",
	61,
	"grass_brown",
	{
		noise_texture = "levels/textures/noise_grass_brown.tex",
		runsound = "dontstarve/movement/run_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_grass_brown.tex"}
)

AddBackwardsCompatibleTile(
	"METAL",
	62,
	"metal",
	{
		noise_texture = "levels/textures/noise_metal.tex",
		runsound = "dontstarve/movement/run_ice",
		walksound = "dontstarve/movement/run_ice",
		snowsound = "dontstarve/movement/run_ice",
		mudsound = "dontstarve/movement/run_ice",
	},
	{noise_texture = "levels/textures/mini_noise_metal.tex"}
)

AddBackwardsCompatibleTile(
	"GRASS_ORANGE",
	63,
	"grass_orange",
	{
		noise_texture = "levels/textures/noise_grass_orange.tex",
		runsound = "dontstarve/movement/run_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_noise_grass_orange.tex"}
)

-- Water turfs
-- AddBackwardsCompatibleTile(
-- 	"OCEAN_SHALLOW",
-- 	63,
-- 	"water_shallow",
-- 	{
-- 		noise_texture = "levels/textures/noise_water_shallow.tex",
-- 		runsound = "dontstarve/movement/run_ice",
-- 		walksound = "dontstarve/movement/run_ice",
-- 		snowsound = "dontstarve/movement/run_ice",
-- 		mudsound = "dontstarve/movememinimap_tile_defnt/run_ice",
-- 	},
-- 	{noise_texture = "levels/textures/mini_noise_water_shallow.tex"}
-- )

-- Ocean
-- GLOBAL.GROUND_WATER_TYPES = {
-- 	"OCEAN_SHALLOW",
-- }

--[[
	Compatible definitions
--]]
-- GLOBAL.GROUND_COMPATIBLE_TYPES = {
-- 	["GRASS_CHESS"] = "GRASS",
-- 	["GRASS_BROWN"] = "GRASS",
-- 	["METAL"] = "ROCKY",
-- 	["OCEAN_SHALLOW"] = "GRASS",
-- }
