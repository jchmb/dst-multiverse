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
modimport("mod_assets.lua")

--[[
	Prefab definitions
--]]
modimport("mod_prefabs.lua")
modimport("prefab_names.lua")
modimport("prefab_descriptions.lua")

--[[
	Import some chatter files
--]]
modimport("scripts/chatter/pigman_blue_chat.lua")
modimport("scripts/chatter/pigman_gray_chat.lua")
modimport("scripts/chatter/mimi_chat.lua")

--[[
	Recipes
--]]
modimport("cookpot_recipes.lua")
modimport("recipes.lua")

--[[
	Minimap icons
--]]
modimport("minimap_icons.lua")

--[[
	Adapting some existing prefabs
--]]

-- Migration portals share the wormhole icon. This is confusing. Use teleportato icon instead.
AddPrefabPostInit("migration_portal", function(prefab)
	prefab.MiniMapEntity:SetIcon("teleportato.png")
end)