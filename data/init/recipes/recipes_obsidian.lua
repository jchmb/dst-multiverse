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

AddItemRecipe(
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

AddItemRecipe(
	"obsidianaxe",
	{
		Ingredient("axe", 1),
        ModIngredient("obsidian", 2),
        ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	OBSIDIAN_TWO,
	"Like a regular axe, only hotter.",
    nil,
    1
)

AddItemRecipe(
	"spear_obsidian",
	{
		Ingredient("spear", 1),
        ModIngredient("obsidian", 3),
        ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	OBSIDIAN_TWO,
	"How about a lil fire with your spear?",
    nil,
    1
)

AddItemRecipe(
	"armor_obsidian",
	{
		Ingredient("armorwood", 1),
        ModIngredient("obsidian", 5),
        ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	OBSIDIAN_TWO,
	"Hot to the touch.",
    nil,
    1
)

AddStructureRecipe(
    "firepit_obsidian",
    {
        Ingredient("log", 3),
        ModIngredient("obsidian", 8),
    },
    GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
    OBSIDIAN_TWO,
    "The fieriest of all fires!",
    "images/inventoryimages/firepit_obsidian.xml",
    "firepit_obsidian_placer"
)
