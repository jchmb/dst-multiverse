--[[
	Antidote
--]]
AddItemRecipe(
	"antidote",
	{
		ModIngredient("venom_gland", 1),
		--Ingredient("phlegm", 1),
		--Ingredient("mucus", 1, "images/inventoryimages/mucus.xml"),
		Ingredient("cutgrass", 2),
		Ingredient("red_cap", 2),
	},
	RECIPETABS.SURVIVAL,
	TECH.SCIENCE_ONE,
	"Cures poison"
)