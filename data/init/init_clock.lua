-- Synchronize seasons
local function UpdateSeasons(self)
    local world = GLOBAL.TheWorld
    world.event_listeners.slave_seasonsupdate = {}
    world.net.event_listening.slave_seasonsupdate = {}
end

-- Clock functions
local OnNextCycle = function()
    _phase:set(#PHASE_NAMES)
    _remainingtimeinphase:set(0)
    self:LongUpdate(0)
end

local OnSimUnpaused = function()
    --Force resync values that client may have simulated locally
    ForceResync(_remainingtimeinphase)
end

local function UpdateClock(self)
	local world = GLOBAL.TheWorld
	world.event_listeners.slave_clockupdate = {}
	world.net.event_listening.slave_clockupdate = {}
    
end

if not GetModConfigBoolean("SynchronizeSeasons") and IsSlaveShard() then
    AddComponentPostInit("seasons", UpdateSeasons)
    AddComponentPostInit("clock", UpdateClock)
end
