--[[
Handles the spawning of the tigershark.
Listens for targets doing "interesting" actions & events (fishing, cooking, eating, surfing etc.)
Rolls a chance against how active the shark is that season & spawns

NOTE: target must be "aquatic" to spawn shark.
--]]

local DEBUG_ALWAYS_SPAWN = false

local SHARK_TUNING = {
	[SEASONS.MILD] =
	{
		actions =
		{
			[ACTIONS.FISH] 		= 0.01,
			[ACTIONS.REEL] 		= 0.01,
			[ACTIONS.CATCH] 	= 0.01,
			[ACTIONS.BAIT] 		= 0.01,
			[ACTIONS.NET] 		= 0.01,
		},
		events = {},
		cooldown = TUNING.TOTAL_DAY_TIME * 7,
	},
	[SEASONS.WET] =
	{
		actions =
		{
			[ACTIONS.FISH] 		= 0.01,
			[ACTIONS.REEL] 		= 0.01,
			[ACTIONS.CATCH] 	= 0.01,
			[ACTIONS.ATTACK]	= 0.01,
			[ACTIONS.BAIT] 		= 0.03,
			[ACTIONS.NET] 		= 0.03,
			[ACTIONS.EAT] 		= 0.03,
		},
		events =
		{
			["boostbywave"] = 0.01,
		},
		cooldown = TUNING.TOTAL_DAY_TIME * 5,
	},
	[SEASONS.GREEN] =
	{
		actions =
		{
			[ACTIONS.FISH] 		= 0.02,
			[ACTIONS.REEL] 		= 0.02,
			[ACTIONS.CATCH] 	= 0.02,
			[ACTIONS.ATTACK]	= 0.02,
			[ACTIONS.BAIT] 		= 0.06,
			[ACTIONS.NET] 		= 0.06,
			[ACTIONS.EAT] 		= 0.06,
		},
		events =
		{
			["boostbywave"] = 0.05,
		},
		cooldown = TUNING.TOTAL_DAY_TIME * 3,
	},
	[SEASONS.DRY] =
	{
		actions =
		{
			[ACTIONS.FISH] 		= 0.01,
			[ACTIONS.REEL] 		= 0.01,
			[ACTIONS.CATCH] 	= 0.01,
			[ACTIONS.BAIT] 		= 0.01,
			[ACTIONS.NET] 		= 0.01,
		},
		events = {},
		cooldown = TUNING.TOTAL_DAY_TIME * 10,
	},
}

local TigerSharker = Class(function(self, inst)
	self.inst = inst

	self.respawn_time = TUNING.TOTAL_DAY_TIME * 20

	self.shark_prefab = "tigershark"
	self.shark = nil --a reference to the shark entity.
	self.shark_data = nil

	self.shark_home = nil --a reference to the shark's home nest

	self.actions = {} --the actions the current season cares about
	self.events = {} --the events the current season cares about	
	self.targets = {} --the targets the spawner cares about

	self.appearance_cooldown = TUNING.TOTAL_DAY_TIME * 5 --Time between shark appearances.
	self.appearance_timer = 0 --Time left until the shark and show up again

	self.respawn_cooldown = TUNING.TOTAL_DAY_TIME * 10 --If the shark dies, how long before it can respawn
	self.respawn_timer = 0 --Time left until shark respawns.

	self.action_chance_mod = 1.0
	self.event_chance_mod = 1.0
	self.cooldown_mod = 1.0
	self.respawn_mod = 1.0

	self.inst:ListenForEvent("seasonChange", function(world, data) 
		if SHARK_TUNING[data.season] then
			self:SetTuning(SHARK_TUNING[data.season])
		end 
	end)
end)

function TigerSharker:TrackTarget(target)
	if not target then
		print("No target passed into TigerSharker:TrackTarget!")
		return
	end

	self.targets[target] = {}

	self.targets[target]["actionsuccess"] = function(inst, data) self:OnAction(data.action, inst) end
	self.inst:ListenForEvent("actionsuccess", self.targets[target]["actionsuccess"], target)

	for event, chance in pairs(self.events) do
		target[event] = function(doer) self:OnEvent(event, doer) end
		self.inst:ListenForEvent(event, target[event], target)
	end
end

function TigerSharker:StopTrackingTarget(target)
	if self.targets[target] then
		for event, fn in pairs(self.targets[target]) do
			self.inst:RemoveEventCallback(event, fn, target)
		end
	end
end

function TigerSharker:FindHome()
	if self.shark_home then
		--There should only ever be one shark home in a world.
		--If you already have a home you don't need to look for it again.
		return
	end

	self.shark_home = FindEntity(self.inst, 10000, nil, {"sharkhome"}, {"FX", "NOCLICK"})
end

function TigerSharker:GetHomePosition()
	if not self.shark_home then
		print("TigerSharker has no home set so it can't return a position!")
		return
	end

	return self.shark_home:GetPosition()
end

function TigerSharker:GetAngleToHome(ent) --Radians
	local home_pos = self:GetHomePosition()
	
	if not home_pos then return end

	local ent_pos = ent:GetPosition()
	local home_vec =  ent_pos - home_pos
	return math.atan2(home_vec.z, home_vec.x)
end

function TigerSharker:TimeUntilRespawn()
	return math.max(self.respawn_timer - GetTime(), 0)
end

function TigerSharker:TimeUntilCanAppear()
	return math.max(self.appearance_timer - GetTime(), 0)
end

function TigerSharker:CanSpawn(ignore_cooldown, ignore_death)
	return (self:TimeUntilCanAppear() <= 0 or ignore_cooldown) and (self:TimeUntilRespawn() <= 0 or ignore_death) and not self.shark and self.shark_home and (self.action_chance_mod > 0.0 or self.event_chance_mod > 0.0)
end

function TigerSharker:OnEvent(event, doer)
	--If we're listening for this and the doer is on the water.
	if self.events[event] and doer:HasTag("aquatic") then
		--Roll against the chance for this event to trigger a spawn.
		if math.random() <= self.event_chance_mod * self.events[event] or DEBUG_ALWAYS_SPAWN then
			self:DoSharkEvent(doer)
		end
	end
end

function TigerSharker:OnAction(action, doer)
	--If we're listening for this and the doer is on the water.
	if self.actions[action.action] and doer:HasTag("aquatic") then
		--Roll against the chance for this event to trigger a spawn.
		if math.random() <= self.action_chance_mod * self.actions[action.action] or DEBUG_ALWAYS_SPAWN then
			self:DoSharkEvent(doer)
		end
	end
end

function TigerSharker:StartApperanceCooldown(timeoverride)
	self.appearance_timer = (timeoverride or (self.appearance_cooldown * self.cooldown_mod)) + GetTime()
end

function TigerSharker:StartRespawnCooldown(timeoverride)
	self.respawn_timer = (timeoverride or (self.respawn_cooldown * self.cooldown_mod)) + GetTime()
end

function TigerSharker:TakeOwnership(shark)
	self.shark = shark

	shark.ts_death_fn = function()
		self.shark_data = nil
		self:Abandon(shark)
		self:StartApperanceCooldown()
		self:StartRespawnCooldown()
	end

	shark.ts_sleep_fn = function()
		shark.shark_wake_fn = function()
			shark:RemoveEventCallback("entitywake", shark.shark_wake_fn)
			shark.shark_remove_task:Cancel()
		end

		shark:ListenForEvent("entitywake", shark.shark_wake_fn)

		shark.shark_remove_task = shark:DoTaskInTime(1, function() 
			self:DespawnShark() 
		end)
	end

	self.inst:ListenForEvent("death", shark.ts_death_fn, shark)
	self.inst:ListenForEvent("entitysleep", shark.ts_sleep_fn, shark)
end

function TigerSharker:Abandon(shark)
	if shark.ts_death_fn then
		self.inst:RemoveEventCallback("death", shark.ts_death_fn, shark)
		shark.ts_death_fn = nil
	end

	if shark.ts_sleep_fn then
		self.inst:RemoveEventCallback("entitysleep", shark.ts_sleep_fn, shark)
		shark.ts_sleep_fn = nil
	end

	self.shark = nil
end

function TigerSharker:GetNearbySpawnPoint(target)
	local to_home = self:GetAngleToHome(target)
	
	if to_home then
		local properties = {target:GetPosition(), -to_home, 40, 12}

		local offset = FindWaterOffset(unpack(properties))

		if not offset then
			offset = FindWalkableOffset(unpack(properties))
		end

		return (offset and target:GetPosition() + offset) or nil
	end
end

function TigerSharker:DoSharkEvent(target)
	local spawnpt = self:GetNearbySpawnPoint(target)

	if spawnpt then
		local shark = self:SpawnShark()

		if shark then
			shark.Transform:SetPosition(spawnpt:Get())

			local home_pos = self:GetHomePosition()
			shark.components.knownlocations:RememberLocation("point_owaf_interest", home_pos)
			
			--Look around the target for something you can interact with (kill)
			local possible_target = FindEntity(target, 20, 
				function(tar) return shark.components.combat:CanTarget(tar) end, 
				nil, {"prey", "player", "companion", "bird", "butterfly", "sharkitten"})

			shark.components.combat:SuggestTarget(possible_target)
		end
	end
end

function TigerSharker:SpawnShark(ignore_cooldown, ignore_death)
	if not self:CanSpawn(ignore_cooldown) then
		return
	end

	local shark = nil

	if self.shark_data then
		shark = SpawnSaveRecord(self.shark_data)
	else
		shark = SpawnPrefab(self.shark_prefab)
	end

	if shark.components.health:GetPercent() < 0.25 then
		shark.components.health:SetPercent(0.25)
	end

	self:TakeOwnership(shark)
	self:StartApperanceCooldown()

	return shark
end

function TigerSharker:DespawnShark()
	if not self.shark then
		return
	end

	local shark = self.shark

	--If the shark isn't dead save the data here
	if shark and not shark.components.health:IsDead() then
		self.shark_data = shark:GetSaveRecord()
	end

	self:Abandon(shark)
	shark:Remove()
end

function TigerSharker:SetTuning(tbl)
	--Stop listening to old events
	for target, listeners in pairs(self.targets) do
		for event, fn in pairs(listeners) do
			--Only remove the listeners in the "events" table. [Don't remove listener for actionsuccess]
			if self.events[event] then 
				self.inst:RemoveEventCallback(event, fn, target)
			end
		end
		listeners = {}
	end

	self.actions = {}
	for action, chance in pairs(tbl.actions) do
		self.actions[action] = chance
	end

	self.events = {}
	for event, chance in pairs(tbl.events) do
		self.events[event] = chance
	end

	--Needs to listen to each event on each tracked target.
	for target, listeners in pairs(self.targets) do
		for event, chance in pairs(self.events) do
			target[event] = function(doer) self:OnEvent(event, doer) end
			self.inst:ListenForEvent(event, target[event], target)
		end
	end

	self.appearance_cooldown = tbl.cooldown
end

function TigerSharker:LongUpdate(dt)
	self.appearance_timer = self.appearance_timer - dt
	self.respawn_timer = self.respawn_timer - dt
end

function TigerSharker:GetDebugString()
	local s = ""

	s = s.."\nACTIONS -- "
	for k,v in pairs(self.actions) do
		local name = k.str
		if type(k.str) == "table" then
			name = k.str["GENERIC"]
		end
		s = s..string.format("%s : %2.1f%%, ", name, v * 100)
	end


	s = s.."\nEVENTS -- "
	for k,v in pairs(self.events) do
		s = s..string.format("%s : %2.1f%%, ", k, v * 100)
	end

	s = s..string.format("\n-- Can Appear In: %2.2f", self:TimeUntilCanAppear() or 0)
	s = s..string.format("\n-- Can Respawn In: %2.2f", self:TimeUntilRespawn() or 0)
	s = s..string.format("\n-- Shark: %s", tostring(self.shark) or "NONE")
	return s
end

function TigerSharker:OnSave()
	local data = {}
	local references = {}

	if self.shark then
		data.shark = self.shark.GUID
		table.insert(references, self.shark.GUID)
	end

	if self.shark_home then
		data.shark_home = self.shark_home.GUID
		table.insert(references, self.shark_home.GUID)
	end

	data.appearance_timer = self:TimeUntilCanAppear()
	data.respawn_timer = self:TimeUntilRespawn()

	data.action_chance_mod = self.action_chance_mod
	data.event_chance_mod = self.event_chance_mod
	data.cooldown_mod = self.cooldown_mod
	data.respawn_mod = self.respawn_mod

	return data, references
end

function TigerSharker:OnLoad(data)
	if data then
		self.action_chance_mod = data.action_chance_mod or self.action_chance_mod
		self.event_chance_mod = data.event_chance_mod or self.event_chance_mod
		self.cooldown_mod = data.cooldown_mod or self.cooldown_mod
		self.respawn_mod = data.respawn_mod or self.respawn_mod

		self:StartApperanceCooldown(data.appearance_timer or 0)
		self:StartRespawnCooldown(data.respawn_timer or 0)
	end
end

function TigerSharker:LoadPostPass(ents, data)
	if data.shark then
		local shark = ents[data.shark]
		if shark then
			shark = shark.entity
			self:TakeOwnership(shark)
		end
	end

	if data.shark_home then
		local shark_home = ents[data.shark_home]
		if shark_home then
			self.shark_home = shark_home.entity
		end
	end
end

function TigerSharker:SetChanceModifier(action, event)
	self.action_chance_mod = action or 1.0
	self.event_chance_mod = event or 1.0
end

function TigerSharker:SetCooldownModifier(appear, respawn)
	self.cooldown_mod = appear or 1.0
	self.respawn_mod = respawn or 1.0
end

return TigerSharker