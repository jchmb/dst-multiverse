modimport("lib/lua_functions.lua")
modimport("lib/tile_adder.lua")
modimport("utils/utils_common.lua")
modimport("utils/utils_worldgen.lua")

GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATIONTABNAME.FOREST_SNOW = "Snowy"
GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATION.FOREST_SNOW = "Snow Forest"
GLOBAL.STRINGS.TAGS.LOCATION.FOREST_SNOW = "Snow Forest"

--[[
	Add Tiles
--]]
modimport("init/ground_definitions.lua")

--[[
	Terrain filters
--]]
GLOBAL.terrain.filter["snake_hole"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["reindeer"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["pighouse_blue"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["pighouse_yellow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["pighouse_gray"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["rabbithole_snow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["leif_snow"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["perma_walrus_camp"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER, GROUND.ROCKY, GROUND.MARSH}
GLOBAL.terrain.filter["coffeebush"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["bittersweetbush"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["mintybush"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["beardlordhouse"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["slurtlehole"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["perma_grassgekko"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["rock_slimey"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["rock_charcoal"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["pond_open"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["spiderden_poisonous"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["spiderden_poisonous_2"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }
GLOBAL.terrain.filter["spiderden_poisonous_3"] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER }

--[[
	Initialization stuff
--]]
modimport("init/mod_layouts.lua")


--[[
	Level scripts
--]]

modimport("scripts/map/locations/location_snow")
modimport("scripts/map/locations/location_slimey")

modimport("scripts/map/tasksets/default_modified_taskset")
modimport("scripts/map/levels/defaultmodifiedlevel")

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
