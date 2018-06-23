chestfunctions = require("scenarios/chestfunctions")


local function OnCreate(inst, scenariorunner)

	local items =
	{
		{
			item = "carrot",
			count = 10,
		},
		{
			item = "coffee",
			count = 1,
		},
	}
	chestfunctions.AddChestItems(inst, items)
end

return
{
	OnCreate = OnCreate
}
