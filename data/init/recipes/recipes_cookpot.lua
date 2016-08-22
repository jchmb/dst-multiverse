--[[
	New ingredients
--]]
AddIngredientValues({"coffeebeans"}, {veggie=1}, true, false)
AddIngredientValues({"bittersweetberries"}, {fruit=1, monster=0.5}, true, false)
AddIngredientValues({"mintyberries"}, {fruit=1}, true, false)
AddIngredientValues({"limpets"}, {fish=0.5}, true, false)

--[[
	New recipes
--]]
AddCookerRecipe("cookpot", {		
	name = "coffee",
	test = function(cooker, names, tags) 
		return names.coffeebeans_cooked
			and ((names.coffeebeans_cooked == 3 and (names.butter or tags.dairy or names.honey or tags.sweetener))
			or (names.coffeebeans_cooked == 4))
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

local preparedFoods = GLOBAL.require("newpreparedfoods")
for k,v in pairs(preparedFoods) do
	AddCookerRecipe("cookpot", v)
end