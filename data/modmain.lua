--[[
	Dependencies
--]]
modimport("lib/lua_functions")
modimport("utils/utils_common")
modimport("utils/utils_main")

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
modimport("init/init_assets")
modimport("init/init_prefabs")
modimport("init/minimap_icons")

--[[
	Names and descriptions
--]]
modimport("init/init_names")
modimport("init/init_descriptions")
modimport("init/init_descriptions_copied")
modimport("init/namegens/wildbeaver_names")

--[[
	Recipes
--]]
modimport("init/init_recipes")

--[[
	Chatter scripts
--]]
modimport("init/init_chatter")

-- Prefab postinits
modimport("init/postinits")

-- Add extra components (caffeinated and poisoned for example)
modimport("init/player_hooks")