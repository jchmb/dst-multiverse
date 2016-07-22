--[[
	Dependencies
--]]
modimport("lib/lua_functions.lua")

--[[
	Globals
--]]
STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe

--[[
	Initialization scripts
--]]
modimport("init/mod_assets.lua")
modimport("init/mod_prefabs.lua")
modimport("init/prefab_names.lua")
modimport("init/prefab_descriptions.lua")
modimport("init/cookpot_recipes.lua")
modimport("init/recipes.lua")
modimport("init/minimap_icons.lua")

--[[
	Chatter scripts
--]]
modimport("scripts/chatter/pigman_blue_chat.lua")
modimport("scripts/chatter/pigman_gray_chat.lua")
modimport("scripts/chatter/mimi_chat.lua")

-- Migration portals share the wormhole icon. This is confusing. Use teleportato icon instead.
AddPrefabPostInit("migration_portal", function(prefab)
	prefab.MiniMapEntity:SetIcon("teleportato.png")
end)
