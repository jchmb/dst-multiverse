chestfunctions = require("scenarios/chestfunctions")
loot =
{
	{
		item = "thulecite",
		count = 1,
	},
	{
		item = "goose_feather",
		count = 2,
	},
	{
		item = "feather_crow",
		count = 3,
	},
	{
		item = "feather_robin",
		count = 3,
	},
	{
		item = "feather_robin_winter",
		count = 3,
	},
}

local function OnCreate(inst, scenariorunner)
	chestfunctions.AddChestItems(inst, loot)
end

return
{
	OnCreate = OnCreate,
}