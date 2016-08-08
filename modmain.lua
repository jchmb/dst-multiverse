--[[
	Dependencies
--]]
modimport("lib/lua_functions.lua")
modimport("utils/utils_common.lua")
modimport("utils/utils_main.lua")

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
modimport("init/mod_prefabs.lua")
modimport("init/minimap_icons.lua")

--[[
	Names and descriptions
--]]
modimport("init/prefab_names.lua")
modimport("init/prefab_descriptions.lua")
modimport("init/prefab_descriptions_copied.lua")

--[[
	Mob name generators
--]]
modimport("init/namegens/wildbeaver_names")

--[[
	Recipes
--]]
modimport("init/init_recipes.lua")

--[[
	Chatter scripts
--]]
modimport("scripts/chatter/pigman_blue_chat.lua")
modimport("scripts/chatter/pigman_gray_chat.lua")
modimport("scripts/chatter/pigman_slimey_chat.lua")
modimport("scripts/chatter/hatbunnyman_chat.lua")
modimport("scripts/chatter/wildbeaver_chat.lua")
modimport("scripts/chatter/mimi_chat.lua")

if GetModConfigData("UseMultiShards") and (GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated()) then
	modimport("init/hooks/portal/hook_migration_portal")
	AddPrefabPostInit("migration_portal", function(prefab)
		-- Migration portals share the wormhole icon. This is confusing. Use teleportato icon instead.
		--prefab.MiniMapEntity:SetIcon("teleportato.png")
		prefab:DoTaskInTime(1, HookInitConnect)
	end)
end

-- Prefab postinits
modimport("init/prefab_postinits")

-- Add extra components (caffeinated and poisoned for example)
modimport("init/player_hooks.lua")