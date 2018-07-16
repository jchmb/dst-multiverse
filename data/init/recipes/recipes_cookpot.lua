--[[
	New ingredients
--]]
local mushrooms = {"brown_cap", "gray_cap", "yellow_cap"}
AddIngredientValues(mushrooms, {veggie=0.5}, true, false)
AddIngredientValues({"coffeebeans"}, {veggie=1}, true, false)
AddIngredientValues({"bittersweetberries"}, {fruit=1, monster=0.5}, true, false)
AddIngredientValues({"mintyberries"}, {fruit=1}, true, false)
AddIngredientValues({"limpets"}, {fish=0.5}, true, false)
AddIngredientValues({"sweet_potato"}, {veggie=1}, true, false)
AddIngredientValues({"crabmeat"}, {fish=1,crab=1}, true, false)
AddIngredientValues({"pufftree_nut_cooked"}, {veggie=0.5}, true, false)

--[[
	New recipes
--]]
AddCookerRecipe("cookpot", {
	name = "coffee",
	test = function(cooker, names, tags)
		return names.coffeebeans_cooked
			and ((names.coffeebeans_cooked == 3 and (names.butter or tags.dairy or names.honey or tags.sweetener))
			or (names.coffeebeans_cooked == 4)
			or (names.coffeebeans_cooked == 2 and (names.butter or tags.dairy) and (names.honey or tags.sweetener)))
	end,
	priority = 10,
	weight = 1,
	foodtype = "PREPARED",
	health = 3,
	hunger = 10,
	perishtime = TUNING.PERISH_FAST,
	sanity = -5,
	cooktime = .25,
	tags = {},
})

AddCookerRecipe(
	"cookpot",
	{
		name = "syrup",
		test = function(cooker, names, tags)
			return names.sap and names.sap == 4
		end,
		priority = 10,
		weight = 1,
		foodtype = "GENERIC",
		health = 20,
		hunger = 5,
		sanity = 5,
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 5,
		tags = {},
	}
)

local preparedFoods = GLOBAL.require("newpreparedfoods")
for k,v in pairs(preparedFoods) do
	AddCookerRecipe("cookpot", v)
end
