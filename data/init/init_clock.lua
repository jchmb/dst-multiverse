-- Synchronize seasons

local function UpdateSeasons(self)
    local world = GLOBAL.TheWorld
    world.event_listeners.slave_seasonsupdate = {}
    world.net.event_listening.slave_seasonsupdate = {}
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
