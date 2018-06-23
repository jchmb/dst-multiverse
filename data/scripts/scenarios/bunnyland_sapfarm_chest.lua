chestfunctions = require("scenarios/chestfunctions")


local function OnCreate(inst, scenariorunner)

	local items =
	{
		{
			item = "sapbucket",
			count = 5,
		},
		{
			item = "log",
			count = 5,
		},
	}
	chestfunctions.AddChestItems(inst, items)
end

return
{
	OnCreate = OnCreate
}
