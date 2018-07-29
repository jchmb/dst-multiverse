chestfunctions = require("scenarios/chestfunctions")
local loot =
{
	{
		item = "meat",
		count = 2,
	},
	{
		item = "smallmeat",
		count = 4,
	},
}

local function triggertrap(inst, scenariorunner, data)
	local player = data.player
	if TheWorld.state.iscaveday then
		TheWorld:PushEvent("ms_nextphase")
	end
	if player and player.components.inventory then
		for i=1,4 do
			local meat = SpawnPrefab("meat")
			player.components.inventory:GiveItem(meat)
		end
	end
end

local function OnCreate(inst, scenariorunner)
	chestfunctions.AddChestItems(inst, loot)
end

local function OnLoad(inst, scenariorunner)
	inst.scene_triggerfn = function(inst, data)
		data.player = data.doer or data.worker
		triggertrap(inst, scenariorunner, data)
		scenariorunner:ClearScenario()
	end
	inst:ListenForEvent("onopen", inst.scene_triggerfn)
	inst:ListenForEvent("worked", inst.scene_triggerfn)
end

local function OnDestroy(inst)
	chestfunctions.OnDestroy(inst)
end


return
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy
}
