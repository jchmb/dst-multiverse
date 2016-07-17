modimport "tile_adder.lua"

-- GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATIONTABNAME.FOREST_SNOW = "Snowy"
-- GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATION.FOREST_SNOW = "Snow Forest"
-- GLOBAL.STRINGS.TAGS.LOCATION.FOREST_SNOW = "Snow Forest"

--[[
	Add Tiles
--]]
AddTile(
	"SNOWY",
	80,
	"snowy",
	{noise_texture = "levels/textures/noise_snowy.tex"},
	{noise_texture = "levels/textures/mini_noise_snowy.tex"}
)

--[[
	Terrain filters
--]]

GLOBAL.terrain.filter["pighouse_blue"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["rabbithole_snow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["leif_snow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}


--[[
	Other stuff
--]]

modimport("scripts/map/locations/location_snow")
modimport("scripts/map/rooms/snow_rooms")
modimport("scripts/map/tasks/snow_tasks")
modimport("scripts/map/tasksets/snow_taskset")
modimport("scripts/map/levels/snowlevel")