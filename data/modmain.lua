--[[
	Dependencies
--]]
modimport("lib/lua_functions")
modimport("utils/utils_common")
modimport("utils/utils_main")
modimport("utils/utils_console")

--[[
	Globals
--]]
STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe

modimport("init/init_tuning")

--[[
	Assets
--]]
modimport("init/init_assets")
modimport("init/minimap_icons")
modimport("init/init_prefabs")

--[[
	Names and descriptions
--]]
modimport("init/init_names")
modimport("init/init_descriptions")
modimport("init/init_descriptions_copied")
modimport("init/namegens/wildbeaver_names")

--[[
	Actions
--]]
modimport("init/init_actions")

--[[
	Recipes
--]]
modimport("init/init_recipes")

--[[
	Chatter scripts
--]]
modimport("init/init_chatter")

--[[
	Misc
--]]
modimport("init/init_kramped")
modimport("init/init_clock")

-- Prefab postinits
modimport("init/postinits")

-- Add extra components (caffeinated and poisoned for example)
modimport("init/player_hooks")
