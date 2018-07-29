chestfunctions = require("scenarios/chestfunctions")
local loot =
{
	{
		item = "froglegs",
		count = 10,
	},
}

local function triggertrap(inst, scenariorunner, data)
	local player = data.player
	inst.SoundEmitter:PlaySound("dontstarve/frog/grunt")
	local n = 12
	if player then
		for i=1,n do
			local pt = Vector3(player.Transform:GetWorldPosition())
			local theta = ((i - 1) / n) * 2 * PI
    		local radius = 30
			local offset = FindWalkableOffset(pt, theta, radius, 12, true)
			if offset then
				local spawn_pt = pt + offset
				local spawn = math.random() <= 0.25 and SpawnPrefab("frog_purple") or SpawnPrefab("frog")
				if spawn then
					spawn.Physics:Teleport(spawn_pt:Get())
					spawn:FacePoint(pt)
					spawn.components.combat:SuggestTarget(player)
				end
			end
		end
	end
end

local function OnCreate(inst, scenariorunner)
	chestfunctions.AddChestItems(inst, loot)
end

local function OnLoad(inst, scenariorunner)
	inst.scene_triggerfn = function(inst, data)
		data.player = data.owner
		triggertrap(inst, scenariorunner, data)
		scenariorunner:ClearScenario()
	end
	inst:ListenForEvent("onpickup", inst.scene_triggerfn)
end

local function OnDestroy(inst)
	if inst.scene_triggerfn then
		inst:RemoveEventCallback("onpickup", inst.scene_triggerfn)
		inst.scene_triggerfn = nil
	end
end

return
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy,
}
