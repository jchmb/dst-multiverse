--[[
	Antidote
--]]
-- AddItemRecipe(
-- 	"sapbucket",
-- 	{
-- 		ModIngredient("ironnugget", 2),
-- 		--Ingredient("phlegm", 1),
-- 		--Ingredient("mucus", 1, "images/inventoryimages/mucus.xml"),
-- 		Ingredient("houndstooth", 1),
-- 	},
-- 	RECIPETABS.SURVIVAL,
-- 	TECH.SCIENCE_ONE,
-- 	"Collect sweet sap from saptrees"
-- )

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

--[[
	Thatchpack
--]]
-- AddItemRecipe(
-- 	"thatchpack",
-- 	{
-- 		ModIngredient("palmleaf", 4),
-- 	},
-- 	RECIPETABS.SURVIVAL,
-- 	TECH.NONE,
-- 	"Carry a light load."
-- )

--[[
	Tropical Parasol
--]]
AddItemRecipe(
	"palmleaf_umbrella",
	{
		Ingredient("twigs", 4),
		ModIngredient("palmleaf", 3),
		Ingredient("petals", 6),
	},
	RECIPETABS.SURVIVAL,
	TECH.NONE,
	"Posh & portable tropical protection."
)

--[[
	Palmleaf Hut
--]]
AddStructureRecipe(
	"palmleaf_hut",
	{
		ModIngredient("palmleaf", 4),
		Ingredient("bamboo", 4),
		Ingredient("rope", 3),
	},
	RECIPETABS.TOWN,
	TECH.SCIENCE_TWO,
	"Escape the rain. Mostly.z"
)
