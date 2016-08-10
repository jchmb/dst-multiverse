local function triggertrap(inst, scenariorunner, data)
	local player = data.player
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_spawner_open_warning")
	if player then
		for i=1,5 do
			local pt = Vector3(player.Transform:GetWorldPosition())
			local theta = ((i - 1) / 5) * 2 * PI
    		local radius = 30
			local offset = FindWalkableOffset(pt, theta, radius, 12, true)
			if offset then
				local spawn_pt = pt + offset
				local spawn = SpawnPrefab("worm")
				if spawn then
					spawn.Physics:Teleport(spawn_pt:Get())
					spawn:FacePoint(pt)
					spawn.components.combat:SuggestTarget(player)
				end
			end
		end
	end
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
	OnLoad = OnLoad,
	OnDestroy = OnDestroy,
}