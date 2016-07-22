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
	Assets
--]]
modimport("init/mod_assets.lua")

--[[
	Prefab definitions
--]]
modimport("init/mod_prefabs.lua")
modimport("init/prefab_names.lua")
modimport("init/prefab_descriptions.lua")

--[[
	Import some chatter files
--]]
modimport("scripts/chatter/pigman_blue_chat.lua")
modimport("scripts/chatter/pigman_gray_chat.lua")
modimport("scripts/chatter/mimi_chat.lua")

--[[
	Recipes
--]]
modimport("init/cookpot_recipes.lua")
modimport("init/recipes.lua")

--[[
	Minimap icons
--]]
modimport("init/minimap_icons.lua")

--[[
	Adapting some existing prefabs
--]]

-- Migration portals share the wormhole icon. This is confusing. Use teleportato icon instead.
AddPrefabPostInit("migration_portal", function(prefab)
	prefab.MiniMapEntity:SetIcon("teleportato.png")
end)