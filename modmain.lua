STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe

PrefabFiles = {
	"pigman_blue",
	"pigman_yellow",
	"pigman_gray",
	"pighouse_yellow",
	"pighouse_blue",
	"pighouse_gray",
	"pigking_blue",
	"pigking_gray",
}

Assets = {
	Asset( "IMAGE", "images/pighouse_yellow.tex" ),
	Asset( "ATLAS", "images/pighouse_yellow.xml" ),
	Asset( "IMAGE", "images/pighouse_blue.tex" ),
	Asset( "ATLAS", "images/pighouse_blue.xml" ),
}

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
STRINGS.NAMES.PIGHOUSE_YELLOW = "Yellowpig House"
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
STRINGS.NAMES.PIGHOUSE_BLUE = "Chillpig House"
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
STRINGS.NAMES.PIGHOUSE_GRAY = "Graypig House"
STRINGS.RECIPE_DESC.PIGHOUSE_GRAY = "Houses one graypig"

--[[
	Secret recipe for creating yellow gems out of phlegm, don't tell your mother.
--]]
Recipe(
	"yellowgem",
	{
		Ingredient("phlegm", 30),
	},
	RECIPETABS.REFINE,
	TECH.LOST
)
