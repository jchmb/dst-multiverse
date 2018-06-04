local coconut_halved = AddItemRecipe(
	"coconut_halved",
	{
		ModIngredient("coconut", 1),
	},
	RECIPETABS.REFINE,
	TECH.NONE,
	"Slice a coconut in half"
)
coconut_halved.numtogive = 2

AddItemRecipe(
	"cloth",
	{
		ModIngredient("bamboo", 3),
	},
	RECIPETABS.REFINE,
	TECH.SCIENCE_ONE,
	"Bamboo is so versatile!"
)

AddItemRecipe(
	"gears",
	{
		ModIngredient("ironnugget", 10),
	},
	RECIPETABS.REFINE,
	TECH.SCIENCE_TWO,
	"Everybody needs gears",
	"images/inventoryimages.xml"
)
