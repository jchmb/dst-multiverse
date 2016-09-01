chestfunctions = require("scenarios/chestfunctions")
local loot =
{
	{
		item = "nightmarefuel",
		count = 3,
	},
	{
		item = "spoiled_food",
		count = 10,
	},
}

local creatures = {
	{
		prefab = "crawlingnightmare",
		count = 4,
	},
}

local function triggertrap(inst, scenariorunner, data)
	local player = data.player
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_spawner_open_warning")
	if player and player.components.sanity then
		player.components.sanity:SetPercent(0.1)
		for i,v in pairs(creatures) do
			for j=1,v.count do
				local creature = SpawnPrefab(v.prefab)
				creature.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
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