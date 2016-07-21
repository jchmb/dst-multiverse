modimport "tile_adder.lua"

GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATIONTABNAME.FOREST_SNOW = "Snowy"
GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATION.FOREST_SNOW = "Snow Forest"
GLOBAL.STRINGS.TAGS.LOCATION.FOREST_SNOW = "Snow Forest"

--[[
	Add Tiles
--]]
AddTile(
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

AddTile(
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

AddTile(
	"ASH",
	51,
	"ash",
	{
		noise_texture = "levels/textures/ground_ash.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_ash.tex"}
)

AddTile(
	"VOLCANO",
	52,
	"volcano",
	{
		noise_texture = "levels/textures/ground_volcano_noise.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_ground_volcano_noise.tex"}
)

AddTile(
	"MAGMA",
	53,
	"magma",
	{
		noise_texture = "levels/textures/Ground_noise_magmafield.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_magmafield_noise.tex"}
)

AddTile(
	"LAVA_ROCK",
	54,
	"lava_rock",
	{
		noise_texture = "levels/textures/ground_lava_rock.tex",
		runsound = "dontstarve/movement/run_mud",
		walksound = "dontstarve/movement/run_mud",
		snowsound = "dontstarve/movement/run_mud",
		mudsound = "dontstarve/movement/run_mud",
	},
	{noise_texture = "levels/textures/mini_lava_noise.tex"}
)

--[[
	Terrain filters
--]]

GLOBAL.terrain.filter["pighouse_blue"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["rabbithole_snow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["leif_snow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["perma_walrus_camp"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["coffeebush"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["beardlordhouse"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }

--[[
	Initialization stuff
--]]

local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
Layouts["MigrationGrass"] = StaticLayout.Get("map/static_layouts/migration_grass")


--[[
	Level scripts
--]]

modimport("scripts/map/locations/location_snow")
modimport("scripts/map/locations/location_slimey")

modimport("scripts/map/rooms/gray_rooms")
modimport("scripts/map/tasks/gray_tasks")
modimport("scripts/map/tasksets/gray_taskset")
modimport("scripts/map/levels/graylevel")

modimport("scripts/map/rooms/snow_rooms")
modimport("scripts/map/tasks/snow_tasks")
modimport("scripts/map/tasksets/snow_taskset")
modimport("scripts/map/levels/snowlevel")

modimport("scripts/map/rooms/cute_rooms")
modimport("scripts/map/tasks/cute_tasks")
modimport("scripts/map/tasksets/cute_taskset")
modimport("scripts/map/levels/cutelevel")

modimport("scripts/map/rooms/slimey_rooms")
modimport("scripts/map/tasks/slimey_tasks")
modimport("scripts/map/tasksets/slimey_taskset")
modimport("scripts/map/levels/slimeylevel")

modimport("scripts/map/rooms/chezz_rooms")
modimport("scripts/map/tasks/chezz_tasks")
modimport("scripts/map/tasksets/chezz_taskset")
modimport("scripts/map/levels/chezzlevel")
