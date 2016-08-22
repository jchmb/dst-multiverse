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
	Cyborg Pighouse Recipe
--]]
local pighouseCyborgRecipe = Recipe(
	"pighouse_cyborg",
	{
		Ingredient("boards", 4),
		Ingredient("gears", 2),
		Ingredient("pigskin", 4),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_cyborg_placer"
)
pighouseCyborgRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_gray.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_CYBORG = "Houses one clockworkpig"

--[[
	These recipes are not supposed to be used... yet.
--]]

AddStructureRecipe(
	"colored_rabbithouse",
	{
		Ingredient("boards", 4),
		Ingredient("carrot", 10),
		Ingredient("manrabbit_tail", 4),
	},
	RECIPETABS.TOWN,
	TECH.LOST
)

AddStructureRecipe(
	"hatrabbithouse",
	{
		Ingredient("boards", 4),
		Ingredient("carrot", 10),
		Ingredient("manrabbit_tail", 4),
	},
	RECIPETABS.TOWN,
	TECH.LOST
)

AddStructureRecipe(
	"beardlordhouse",
	{
		Ingredient("boards", 4),
		Ingredient("monstermeat", 2),
		Ingredient("beardhair", 4),
	},
	RECIPETABS.TOWN,
	TECH.LOST
)

AddStructureRecipe(
	"mutant_rabbithouse",
	{
		Ingredient("boards", 4),
		Ingredient("monstermeat", 2),
		Ingredient("rot", 10),
	},
	RECIPETABS.TOWN,
	TECH.LOST
)

AddStructureRecipe(
	"wildbeaver_house",
	{
		Ingredient("boards", 2),
		Ingredient("twigs", 4),
		Ingredient("rope", 1),
		Ingredient("log", 8),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"Houses one Wildbeaver"
)