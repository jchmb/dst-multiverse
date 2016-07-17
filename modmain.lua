-- General globals
STRINGS = GLOBAL.STRINGS

-- Recipe globals
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe

Assets = {
	Asset("IMAGE", "levels/textures/noise_snowy.tex"),
	Asset("IMAGE", "levels/textures/mini_noise_snowy.tex"),
	Asset("IMAGE", "levels/tiles/snowy.tex"),
	Asset("FILE", "levels/tiles/snowy.xml"),
	Asset("IMAGE", "images/pighouse_yellow.tex" ),
	Asset("ATLAS", "images/pighouse_yellow.xml" ),
	Asset("IMAGE", "images/pighouse_blue.tex" ),
	Asset("ATLAS", "images/pighouse_blue.xml" ),
	Asset("IMAGE", "images/pighouse_gray.tex" ),
	Asset("ATLAS", "images/pighouse_gray.xml" ),
}

--[[
	Ground definitions
--]]

PrefabFiles = {
	-- Location prefabs
	--"forest_snow",
	--"forest_snow_network",

	-- Bluepig prefabs
	"pigman_blue",
	"pighouse_blue",
	"pigking_blue",

	-- Yellowpig prefabs
	"pigman_yellow",
	"pighouse_yellow",

	-- Graypigs prefabs
	"pigman_gray",
	"pighouse_gray",
	"pigking_gray",

	-- Snow mobs and spawners
	"rabbithole_snow",
	"rabbit_snow",
	"leif_snow",
	"pond_open",
	"reingoat",
	"reingoatherd",
	
	-- Misc
	"new_turfs",
}

--[[
	Some new names
--]]

STRINGS.NAMES.TURF_SNOWY = "Snowy Turf"
STRINGS.NAMES.PIGKING_GRAY = "Graypig King"
STRINGS.NAMES.PIGKING_BLUE = "Chillpig King"
STRINGS.NAMES.PIGHOUSE_BLUE = "Chillpig House"
STRINGS.NAMES.PIGHOUSE_YELLOW = "Yellowpig House"
STRINGS.NAMES.PIGHOUSE_GRAY = "Graypig House"
STRINGS.NAMES.RABBIT_SNOW = "Snow Rabbit"
STRINGS.NAMES.RABBITHOLE_SNOW = "Rabbithole"
STRINGS.NAMES.LEIF_SNOW = "Snow Treeguard"
STRINGS.NAMES.POND_OPEN = "Pond"
STRINGS.NAMES.REINGOAT = "Reingoat"

--[[
	Import some chatter files
--]]

modimport("scripts/chatter/pigman_blue_chat.lua")
modimport("scripts/chatter/pigman_gray_chat.lua")


--[[
	Yellow Pighouse Recipe
--]]
local pighouseYellowRecipe = Recipe(
	"pighouse_yellow",
	{
		Ingredient("boards", 4),
		Ingredient("pigskin", 4),
		Ingredient("phlegm", 7),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_yellow_placer"
)
pighouseYellowRecipe.atlas = GLOBAL.resolvefilepath("images/pighouse_yellow.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_YELLOW = "Houses one yellowpig"

--[[
	Blue Pighouse Recipe
--]]
local pighouseBlueRecipe = Recipe(
	"pighouse_blue",
	{
		Ingredient("boards", 4),
		Ingredient("cutstone", 3),
		Ingredient("pigskin", 3),
		Ingredient("ice", 10),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_blue_placer"
)
pighouseBlueRecipe.atlas = GLOBAL.resolvefilepath("images/pighouse_blue.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_BLUE = "Houses one chillpig"


--[[
	Gray Pighouse Recipe
--]]
local pighouseGrayRecipe = Recipe(
	"pighouse_gray",
	{
		Ingredient("boards", 4),
		Ingredient("cutstone", 3),
		Ingredient("pigskin", 3),
		Ingredient("nightmarefuel", 3),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_gray_placer"
)
pighouseGrayRecipe.atlas = GLOBAL.resolvefilepath("images/pighouse_blue.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_GRAY = "Houses one graypig"