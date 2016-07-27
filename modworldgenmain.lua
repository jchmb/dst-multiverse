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
modimport("init/ground_filter.lua")

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

--[[
modimport("scripts/map/rooms/fire_rooms")
modimport("scripts/map/tasks/fire_tasks")
modimport("scripts/map/tasksets/fire_taskset")
modimport("scripts/map/levels/firelevel")
--]]