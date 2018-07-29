local TECH = _G.TECH
local STRINGS = _G.STRINGS

AddNewTechTree("OBSIDIAN", 3)

AddRecipeTab(
    "OBSIDIAN",
    10,
    "images/inventoryimages/obsidian.xml",
    "obsidian.tex",
    nil,
    true
)
STRINGS.TABS.OBSIDIAN = "Obsidian"

AddItemRecipe(
	"ironnugget",
	{
		Ingredient("gears", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	TECH.OBSIDIAN_THREE,
	"Destroy gears for their iron!",
    nil,
    5,
    true
)

AddItemRecipe(
	"obsidianaxe",
	{
		Ingredient("axe", 1),
        ModIngredient("obsidian", 2),
        ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	TECH.OBSIDIAN_THREE,
	"Like a regular axe, only hotter.",
    nil,
    1,
    true
)

AddItemRecipe(
	"spear_obsidian",
	{
		Ingredient("spear", 1),
        ModIngredient("obsidian", 3),
        ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	TECH.OBSIDIAN_THREE,
	"How about a lil fire with your spear?",
    nil,
    1,
    true
)

AddItemRecipe(
	"armor_obsidian",
	{
		Ingredient("armorwood", 1),
        ModIngredient("obsidian", 5),
        ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	TECH.OBSIDIAN_THREE,
	"Hot to the touch.",
    nil,
    1,
    true
)

AddStructureRecipe(
    "firepit_obsidian",
    {
        Ingredient("log", 3),
        ModIngredient("obsidian", 8),
    },
    GLOBAL.RECIPETABS.LIGHT,
    TECH.OBSIDIAN_TWO,
    "The fieriest of all fires!",
    "images/inventoryimages/firepit_obsidian.xml",
    "firepit_obsidian_placer"
)

AddItemRecipe(
	"obsidiancoconade",
	{
		ModIngredient("coconade", 3),
		ModIngredient("obsidian", 3),
		ModIngredient("dragoonheart", 1),
	},
	GLOBAL.CUSTOM_RECIPETABS.OBSIDIAN,
	TECH.OBSIDIAN_THREE,
	"KA-BLAMMIER!",
    nil,
    3,
    true
)
