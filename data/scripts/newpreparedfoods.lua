local preparedFoods = {
	coffeeham =
	{
		test = function(cooker, names, tags)
			return names.coffeebeans_cooked and tags.meat and tags.meat > 1.5 and not tags.inedible
		end,
		priority = 11,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_TINY,
		hunger = TUNING.CALORIES_HUGE,
		perishtime = TUNING.PERISH_SLOW,
		sanity = -TUNING.SANITY_TINY,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		cooktime = 2,
		tags = {"caffeinated"},
		oneat = function(inst, eater)
			if eater.components.caffeinated then
				eater.components.caffeinated:Caffeinate(1.2, 60 * 2)
			end
		end,
	},
}

for k,v in pairs(preparedFoods) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
end

return preparedFoods
