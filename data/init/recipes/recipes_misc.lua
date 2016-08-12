--[[
	Antidote
--]]
local antidoteRecipe = Recipe(
	"antidote",
	{
		Ingredient("venom_gland", 1, "images/inventoryimages/venom_gland.xml"),
		--Ingredient("phlegm", 1),
		--Ingredient("mucus", 1, "images/inventoryimages/mucus.xml"),
		Ingredient("cutgrass", 2),
		Ingredient("red_cap", 2),
	},
	RECIPETABS.SURVIVAL,
	TECH.SCIENCE_ONE
)
antidoteRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/antidote.xml")
STRINGS.RECIPE_DESC.ANTIDOTE = "Cures poison"