GLOBAL.global("JUDGEMENTS")
GLOBAL.JUDGEMENTS = {
	["pigman"] = function(victim)
			if not victim.components.werebeast or not victim.components.werebeast:IsInWereState() then
				return 3
			else
				return 0	
			end
		end,
	["babybeefalo"] = 6,
	["teenbird"] = 2,
	["smallbird"] = 6,
	["beefalo"] = 4,
	["crow"] = 1,
	["robin"] = 2,
	["robin_winter"] = 2,
	["butterfly"] = 1,
	["rabbit"] = 1,
	["mole"] = 1,
	["tallbird"] = 2,
	["bunnyman"] = 3,
	["penguin"] = 2,
	["glommer"] = 50,
	["catcoon"] = 5,
}
