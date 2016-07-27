--[[
	Yellow Pighouse Recipe
--]]
local pighouseYellowRecipe = Recipe(
	"pighouse_yellow",
	{
		Ingredient("boards", 4),
		Ingredient("pigskin", 3),
		Ingredient("phlegm", 2),
		Ingredient("mucus", 5, "images/inventoryimages/mucus.xml"),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_yellow_placer"
)
pighouseYellowRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_yellow.xml")
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
pighouseBlueRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_blue.xml")
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
pighouseGrayRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_gray.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_GRAY = "Houses one graypig"

--[[
	Antidote
--]]
local antidoteRecipe = Recipe(
	"antidote",
	{
		Ingredient("venom_gland", 1, "images/inventoryimages/venom_gland.xml"),
		Ingredient("phlegm", 1),
		Ingredient("mucus", 1, "images/inventoryimages/mucus.xml"),
	},
	RECIPETABS.SURVIVAL,
	TECH.SCIENCE_ONE
)
antidoteRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/antidote.xml")
STRINGS.RECIPE_DESC.ANTIDOTE = "Cures poison"