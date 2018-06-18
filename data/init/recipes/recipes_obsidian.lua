local TechTree = GLOBAL.require("techtree")
local OBSIDIAN_TWO = TechTree.Create({OBSIDIAN = 2})

AddRecipeTab(
    "OBSIDIAN",
    10,
    "images/inventoryimages/obsidian.xml",
    "obsidian.tex",
    nil,
    true
)

local ironnugget = AddItemRecipe(
	"ironnugget",
	{
		Ingredient("gears", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	OBSIDIAN_TWO,
	"Destroy gears for their iron!",
    nil,
    5
)
ironnugget.nounlock = true
