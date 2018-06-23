local TechTree = GLOBAL.require("techtree")
local MEALING_STONE_ONE = TechTree.Create({MEALING_STONE = 1})

AddStructureRecipe(
    "mealingstone",
    {
        Ingredient("rocks", 12),
    },
    RECIPETABS.TOWN,
    TECH.SCIENCE_ONE,
    "Grind stuff to make other stuff",
    "images/inventoryimages.xml",
    "mealingstone_placer"
)

local salt = AddItemRecipe(
	"salt",
	{
		Ingredient("saltrock", 1),
	},
	RECIPETABS.REFINE,
	MEALING_STONE_ONE,
	"Make food last longer and taste better",
    "images/inventoryimages.xml",
    3
)
salt.image = "quagmire_salt.tex"

local spotspice_ground = AddItemRecipe(
    "spotspice_ground",
    {
        Ingredient("spotspice_sprig", 3),
    },
    RECIPETABS.REFINE,
    MEALING_STONE_ONE,
    "Make spice from sprigs",
    "images/inventoryimages.xml",
    3
)
spotspice_ground.image = "quagmire_spotspice_ground.tex"
