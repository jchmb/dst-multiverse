require("constants")

TUNING.WAVE_LANE_SPACING = 12

local easing = require("easing")

local function SpawnWaveShimmerShallow(inst, x, y, z)
	local wave = SpawnPrefab( "wave_shimmer" )
	wave.Transform:SetPosition( x, y, z )
end

local function SpawnWaveShimmerMedium(inst, x, y, z)
	local wave = SpawnPrefab( "wave_shimmer_med" )
	wave.Transform:SetPosition( x, y, z )
end

local function SpawnWaveShimmerDeep(inst, x, y, z)
	local wave = SpawnPrefab( "wave_shimmer_deep" )
	wave.Transform:SetPosition( x, y, z )
end

local function SpawnWaveShimmerFlood(inst, x, y, z)
	local wave = SpawnPrefab( "wave_shimmer_flood" )
	wave.Transform:SetPosition( x, y, z )
end

local function GetWaveBearing(ex, ey, ez, lines)
	-- TheSim:ProfilerPush("GetWaveBearing")

	local offs =
	{
		{-2,-2}, {-1,-2}, {0,-2}, {1,-2}, {2,-2},
		{-2,-1}, {-1,-1}, {0,-1}, {1,-1}, {2,-1},
		{-2, 0}, {-1, 0},		  {1, 0}, {2, 0},
		{-2, 1}, {-1, 1}, {0, 1}, {1, 1}, {2, 1},
		{-2, 2}, {-1, 2}, {0, 2}, {1, 2}, {2, 2}
	}

	--TheSim:SetDebugRenderEnabled(true)
	--inst.draw = inst.entity:AddDebugRender()
	--inst.draw:Flush()
	--inst.draw:SetRenderLoop(true)
	--inst.draw:SetZ(0.15)

	local map = GetWorld().Map
	local flooding = GetWorld().Flooding
	local width, height = map:GetSize()
	local halfw, halfh = 0.5 * width, 0.5 * height
	--local ex, ey, ez = inst.Transform:GetWorldPosition()
	local x, y = map:GetTileXYAtPoint(ex, ey, ez)
	local xtotal, ztotal, n = 0, 0, 0
	for i = 1, #offs, 1 do
		local ground = map:GetTile( x + offs[i][1], y + offs[i][2] )
		if map:IsLand(ground) and not (flooding and flooding:OnFlood(ex + offs[i][1] * TILE_SCALE, ey, ez + offs[i][2] * TILE_SCALE)) then
			--if lines then table.insert(lines, {ex, ez, ((x + offs[i][1] - halfw) * TILE_SCALE), ((y + offs[i][2] - halfh) * TILE_SCALE), 1, 1, 0, 1}) end
			xtotal = xtotal + ((x + offs[i][1] - halfw) * TILE_SCALE)
			ztotal = ztotal + ((y + offs[i][2] - halfh) * TILE_SCALE)
			n = n + 1
		end
	end

	local bearing = nil
	if n > 0 then
		local a = math.atan2(ztotal/n - ez, xtotal/n - ex)
		--if lines then table.insert(lines, {ex, ez, ex + 10 * math.cos(a), ez + 10 * math.sin(a), 0, 1, 0, 1}) end
		--if lines then table.insert(lines, {ex, ez, ex + math.cos(0), ez + math.sin(0), 1, 0, 1, 1}) end
		bearing = -a/DEGREES - 90
	end

	-- TheSim:ProfilerPop()

	return bearing
end

local function SpawnWaveShore(inst, x, y, z)
	-- TheSim:ProfilerPush("SpawnWaveShore")
	--local lines = {}
	local bearing = GetWaveBearing(x, y, z)
	if bearing then
		local wave = SpawnPrefab( "wave_shore" )
		wave.Transform:SetPosition( x, y, z )
		wave.Transform:SetRotation(bearing)
		wave:SetAnim()

		--[[TheSim:SetDebugRenderEnabled(true)
		wave.draw = wave.entity:AddDebugRender()
		wave.draw:Flush()
		wave.draw:SetRenderLoop(true)
		wave.draw:SetZ(0.15)
		for i = 1, #lines, 1 do
			wave.draw:Line(lines[i][1], lines[i][2], lines[i][3], lines[i][4], lines[i][5], lines[i][6], lines[i][7], lines[i][8])
		end]]
	end
	-- TheSim:ProfilerPop()
end

local function SpawnWaveFlood(inst, x, y, z)
	-- TheSim:ProfilerPush("SpawnWaveFlood")
	SpawnWaveShimmerFlood(inst, x, y, z)
	SpawnWaveShore(inst, x, y, z)
	-- TheSim:ProfilerPop()
end

local function SpawnWaveRipple(inst, x, y, z, angle, speed)
	-- TheSim:ProfilerPush("SpawnWaveRipple")
	local wave = SpawnPrefab( "wave_ripple" )
	wave.Transform:SetPosition( x, y, z )

	--we just need an angle...
	wave.Transform:SetRotation(angle)

	--motor vel is relative to the local angle, since we're now facing the way we want to go we just go forward
	wave.Physics:SetMotorVel(speed, 0, 0)

	wave.idle_time = inst.ripple_idle_time

	-- TheSim:ProfilerPop()
	return wave
end

local function SpawnRogueWave(inst, x, y, z, angle, speed)
	-- TheSim:ProfilerPush("SpawnRogueWave")
	local wave = SpawnPrefab( "rogue_wave" )
	wave.Transform:SetPosition( x, y, z )
	wave.Transform:SetRotation(angle)

	--motor vel is relative to the local angle, since we're now facing the way we want to go we just go forward
	wave.Physics:SetMotorVel(speed, 0, 0)

	wave.idle_time = inst.ripple_idle_time

	-- TheSim:ProfilerPop()
	return wave
end

local function SpawnLaneWaveRipple(inst, x, y, z, row_radius, col_radius)
	-- TheSim:ProfilerPush("SpawnLaneWaveRipple")
	local ocean = GetWorld().components.ocean
	local sm = GetSeasonManager()
	local cx, cy, cz = ocean:GetCurrentVec3() --assuming unit vector here
	local m1 = math.floor(math.random(-row_radius, row_radius)) --math.random(-16, 16)
	local m2 = TUNING.WAVE_LANE_SPACING * math.floor(math.random(-col_radius, col_radius)) --math.random(-2, 2)
	local dx, dz = 2 * m1 * cx + m2 * cz, 2 * m1 * cz + m2 * -cx
	local tx, ty, tz = x + dx, y, z + dz

	local ground = GetWorld().Map:GetTileAtPoint( tx, ty, tz )
	if ground == GROUND.OCEAN_MEDIUM or ground == GROUND.OCEAN_DEEP then
		local noSpawn = TheSim:FindEntities(tx, ty, tz, 10, {"nowaves"})
		if noSpawn == nil or #noSpawn == 0 then
			local ents = TheSim:FindEntities(tx, ty, tz, 4, {"lanewave"})

			if ents == nil or #ents == 0 then
				local wave
				if (sm:IsWetSeason() and math.random() < easing.inOutCirc(sm:GetPercentSeason(), 0.0, 1.0, 1.0)) or (math.random() < 0.25 and GetClock():GetMoonPhase() == "full") then
					wave = SpawnRogueWave(inst, tx, ty, tz, -ocean:GetCurrentAngle(), inst.ripple_speed * ocean:GetCurrentSpeed() * TUNING.ROGUEWAVE_SPEED_MULTIPLIER)
				else
					wave = SpawnWaveRipple(inst, tx, ty, tz, -ocean:GetCurrentAngle(), inst.ripple_speed * ocean:GetCurrentSpeed())
				end
				wave:AddTag("lanewave")
			end
		end
	end
	-- TheSim:ProfilerPop()
end

local function isWater(map, x, y, z)
	local ground = map:GetTileAtPoint(x, y, z)
	return map:IsWater(ground) or GetWorld().Flooding:OnFlood(x,y,z)
end

local function isSurroundedByWater(map, x, y, z, radius)
	-- TheSim:ProfilerPush("isSurroundedByWater")

	for i = -radius, radius, 1 do
		if not isWater(map, x - radius, y, z + i) or not isWater(map, x + radius, y, z + i) then
			return false
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if not isWater(map, x + i, y, z -radius) or not isWater(map, x + i, y, z + radius) then
			return false
		end
	end

	-- TheSim:ProfilerPop()
	return true
end

local function checkground(inst, map, x, y, z, ground)
	return map:GetTileAtPoint( x, y, z ) == ground
end

local function checkflood(inst, map, x, y, z, ground)
	return GetWorld().Flooding:OnFlood( x, y, z ) and isSurroundedByWater(map, x, y, z, 2)
end

local function checkshore(inst, map, x, y, z, ground)
	return map:GetTileAtPoint( x, y, z ) == ground
end

local WaveManager = Class(function(self, inst)
	self.inst = inst

	self.shimmer =
	{
		-- [GROUND.OCEAN_SHORE] = {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},
		[GROUND.WATER_SHALLOW] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerShallow},
		-- [GROUND.OCEAN_CORAL] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerShallow},
		-- [GROUND.OCEAN_CORAL_SHORE] = {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},
		-- [GROUND.OCEAN_MEDIUM] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerMedium},
		-- [GROUND.OCEAN_DEEP] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep},
		-- [GROUND.OCEAN_SHIPGRAVEYARD] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep},
		-- [GROUND.FLOOD] = {per_sec = 80, spawn_rate = 0, checkfn = checkflood, spawnfn = SpawnWaveFlood},
		-- [GROUND.MANGROVE] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerShallow},
		-- [GROUND.MANGROVE_SHORE] = {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},
	}

	self.ripple_speed = 1.5
	self.ripple_per_sec = 10
	self.ripple_idle_time = 5
	self.ripple_spawn_rate = 0

	self.shimmer_per_sec_mod = 1.0
	self.ripple_per_sec_mod = 1.0
	self.camera_per_sec_mod = 1.0

	self.inst:StartUpdatingComponent(self)
end)

local function DebugDraw(inst)
	if inst.draw then
		inst.draw:Flush()
		inst.draw:SetRenderLoop(true)
		inst.draw:SetZ(0.15)

		local px, py, pz = GetPlayer().Transform:GetWorldPosition()
		local cx, cy, cz = GetWorld().components.ocean:GetCurrentVec3()

		inst.draw:Line(px, pz, 50 * cx + px, 50 * cz + pz, 0, 0, 255, 255)

		local rad = GetWorld().components.ocean:GetCurrentAngle() * DEGREES
		local x, z = 25 * math.cos(rad), 25 * math.sin(rad)

		inst.draw:Line(px, pz, px + x, pz + z, 0, 128, 255, 255)
	else
		TheSim:SetDebugRenderEnabled(true)
		inst.draw = inst.entity:AddDebugRender()
	end
end

function WaveManager:SpawnImpactWave(x, y, z, speed, count)
	local angle = 0
	local angled = 360 / count
	for i = 1, count, 1 do
		SpawnWaveRipple(self, x, y, z, angle, speed)
		angle = angle + angled
	end
end

local function getRippleRadius()
	-- From values from camera_volcano.lua, camera range 30 to 100
	local percent = (TheCamera:GetDistance() - 30) / (70)
	local row_radius = (24 - 16) * percent + 16
	local col_radius = (8 - 2) * percent + 2
	--print("Ripple ", row_radius, col_radius)
	return row_radius, col_radius
end

local function getShimmerRadius()
	-- From values from camera_volcano.lua, camera range 30 to 100
	local percent = (TheCamera:GetDistance() - 30) / (70)
	local radius = (75 - 30) * percent + 30
	--print("Shimmer ", TheCamera:GetDistance(), radius)
	return radius
end

local function getPerSecMult(min, max)
	-- From values from camera_volcano.lua, camera range 30 to 100
	local percent = (TheCamera:GetDistance() - 30) / (70)
	local mult = (1.5 - 1) * percent + 1 -- 1x to 1.5x
	--print("Per sec", TheCamera:GetDistance(), mult)
	return mult
end

local function getSeasonMult()
	local sm = GetSeasonManager()
	local mult = 1.0
	if sm:IsDrySeason() then
		local percent = sm:GetPercentSeason()
		mult = 0.5 * math.sin(PI * percent + (PI/2.0)) + 0.5
	end
	return mult
end

function WaveManager:OnUpdate(dt)
	local map = GetWorld().Map
	if map == nil then
		return
	end

	local ocean = GetWorld().components.ocean
	local px, py, pz = GetPlayer().Transform:GetWorldPosition()
	local mult = getPerSecMult()
	local seasonmult = getSeasonMult()

	if ocean:GetCurrentSpeed() > 0.0 then
		self.ripple_spawn_rate = self.ripple_spawn_rate + self.ripple_per_sec * self.ripple_per_sec_mod * mult * seasonmult * dt

		--print(self.ripple_spawn_rate .. " " .. self.shimmer_spawn_rate)

		local row_radius, col_radius = getRippleRadius()

		while self.ripple_spawn_rate > 1.0 do
			--snap to map lanes
			local w, h = map:GetSize()
			local gridw, gridh = TUNING.WAVE_LANE_SPACING, TUNING.WAVE_LANE_SPACING
			local lx, ly, lz = math.floor(px / gridw) * gridw, py, math.floor(pz / gridh) * gridh
			SpawnLaneWaveRipple(self, lx, ly, lz, row_radius, col_radius)
			self.ripple_spawn_rate = self.ripple_spawn_rate - 1.0
		end

	end

	local radius = getShimmerRadius()
	for g, shimmer in pairs(self.shimmer) do
		shimmer.spawn_rate = shimmer.spawn_rate + shimmer.per_sec * self.shimmer_per_sec_mod * mult * dt
		while shimmer.spawn_rate > 1.0 do
			local dx, dz = radius * UnitRand(), radius * UnitRand()
			local x, y, z = px + dx, py, pz + dz

			if shimmer.checkfn(self, map, x, y, z, g) then
				shimmer.spawnfn(self, x, y, z)
			end
			shimmer.spawn_rate = shimmer.spawn_rate - 1.0
		end

	end

	if self.shimmer_per_sec_mod <= 0.0 and self.ripple_per_sec_mod <= 0.0 and self.camera_per_sec_mod <= 0.0 then
		self.inst:StopUpdatingComponent(self)
	end

	--DebugDraw(self)
end

function WaveManager:SetWaveSettings(shimmer_per_sec, ripple_per_sec, camera_per_sec)
	self.shimmer_per_sec_mod = shimmer_per_sec or 1.0
	self.ripple_per_sec_mod = ripple_per_sec or 1.0
	self.camera_per_sec_mod = camera_per_sec or 1.0
end

function WaveManager:OnSave()
	return
	{
		shimmer_per_sec_mod = self.shimmer_per_sec_mod,
		ripple_per_sec_mod = self.ripple_per_sec_mod,
		camera_per_sec_mod = self.camera_per_sec_mod
	}
end

function WaveManager:OnLoad(data)
	if data then
		self.shimmer_per_sec_mod = data.shimmer_per_sec_mod or self.shimmer_per_sec_mod
		self.ripple_per_sec_mod = data.ripple_per_sec_mod or self.ripple_per_sec_mod
		self.camera_per_sec_mod = data.camera_per_sec_mod or self.camera_per_sec_mod
	end
end

return WaveManager
