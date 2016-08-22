GLOBAL.global("JUDGEMENTS")

local function pigmanfn(victim)
	if not victim.components.werebeast or not victim.components.werebeast:IsInWereState() then
		return 3
	else
		return 0	
	end
end

GLOBAL.JUDGEMENTS = {
	["pigman"] = pigmanfn,
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

	-- Extra
	["pigman_blue"] = pigmanfn,
	["pigman_gray"] = pigmanfn,
	["pigman_yellow"] = pigmanfn,
	["colored_bunnyman"] = 3,
	["hatbunnyman"] = 3,
	["perma_beardlord"] = 2,
	["wildbeaver"] = 3,
	["ox"] = 4,
	["babyox"] = 6,
}