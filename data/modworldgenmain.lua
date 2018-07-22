modimport("lib/lua_functions.lua")
modimport("lib/tile_adder.lua")
modimport("utils/utils_common.lua")
modimport("utils/utils_worldgen.lua")

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
modimport("init/init_layouts.lua")


--[[
	Locations
--]]
modimport("scripts/map/locations/location_bunnyland")
modimport("scripts/map/locations/location_snow")
modimport("scripts/map/locations/location_slimey")
modimport("scripts/map/locations/location_gray")
modimport("scripts/map/locations/location_water")
modimport("scripts/map/locations/location_chezz")
modimport("scripts/map/locations/location_fire")

--[[
	Level scripts
--]]
if GetModConfigBoolean("UseMigrationPortals") then
	modimport("scripts/map/tasksets/default_modified_taskset")
	modimport("scripts/map/levels/defaultmodifiedlevel")
end

if HasGorgePort() then
	AddPreferredLayout("GorgeSafe", "gorge_safe")
	AddPreferredLayout("GorgeSafe2", "gorge_safe_2")
end

modimport("scripts/map/rooms/multi_rooms")
modimport("scripts/map/tasks/multi_tasks")
modimport("scripts/map/tasksets/multi_taskset")
modimport("scripts/map/levels/multilevel")
modimport("scripts/map/start_locations/start_location_multi")

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
modimport("scripts/map/start_locations/start_location_bunnyland")

modimport("scripts/map/rooms/slimey_rooms")
modimport("scripts/map/tasks/slimey_tasks")
modimport("scripts/map/tasksets/slimey_taskset")
modimport("scripts/map/levels/slimeylevel")

modimport("scripts/map/rooms/chezz_rooms")
modimport("scripts/map/tasks/chezz_tasks")
modimport("scripts/map/tasksets/chezz_taskset")
modimport("scripts/map/levels/chezzlevel")

modimport("scripts/map/rooms/water_rooms")
modimport("scripts/map/tasks/water_tasks")
modimport("scripts/map/tasksets/water_taskset")
modimport("scripts/map/levels/waterlevel")

modimport("scripts/map/rooms/fire_rooms")
modimport("scripts/map/tasks/fire_tasks")
modimport("scripts/map/tasksets/fire_taskset")
modimport("scripts/map/levels/firelevel")
