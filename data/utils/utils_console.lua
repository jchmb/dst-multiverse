local function FuzzyMatchPlayer(name)
    local bestPlayer = nil
    local bestDistance = 5
    local distance = 5
    for i,v in ipairs(GLOBAL.AllPlayers) do
        distance = Levenshtein(bestPlayer.name, name)
        if distance < bestDistance then
            bestDistance = distance
            bestPlayer = v
        end
    end
    return bestPlayer
end

local function FreezePlayer(player, freeze)
    if freeze then
        player.components.locomotor:SetExternalSpeedMultiplier(player, "admin", 0)
    else
        player.components.locomotor:RemoveExternalSpeedMultiplier(player, "admin")
    end
end

local function FreezeAllPlayers(freeze)
    for i,v in ipairs(AllPlayers) do
        FreezePlayer(v, freeze)
    end
end

local function c_ext()
    local player = GLOBAL.ConsoleCommandPlayer()
    local x, y, z = player.Transform:GetWorldPosition()
    local range = 50
    local entities = TheSim:FindEntities(x, y, z, range, function(e)
        return target.components.burnable and
            (target.components.burnable:IsBurning() or target.components.IsSmoldering())
    end)
    for i,v in ipairs(entities) do
        v.components.burnable:Extinguish()
    end
end

local function c_travel(worldName)
    local worldId = nil
    for k,v in pairs(GetModConfigData("WorldNames")) do
        if v == worldName then
            worldId = k
        end
    end

    if worldId then
        local data = {worldid = worldId, portalid = 666}
        GLOBAL.TheWorld:PushEvent("ms_playerdespawnandmigrate", data)
    end
end

local function c_invisible()
    local player = GLOBAL.ConsoleCommandPlayer()
    if not player.invisible then
        player.AnimState:SetMultColour(0, 0, 0, 0)
        player.invisible = true
    else
        player.AnimState:SetMultColour(1, 1, 1, 1)
        player.invisible = false
    end
end

local function c_adminmode()
    GLOBAL.c_supergodmode()
    GLOBAL.c_speedmult(5)
    GLOBAL.c_give("minerhat")
    GLOBAL.c_give("lightbulb", 20)
end

local function c_freeze(name)
    local player = FuzzyMatchPlayer(name)
    if player then
        FreezePlayer(player, true)
    end
end

local function c_unfreeze(name)
    local player = FuzzyMatchPlayer(name)
    if player then
        FreezePlayer(player, false)
    end
end

local function c_freezeall()
    FreezeAllPlayers(true)
end

local function c_unfreezeall()
    FreezeAllPlayers(false)
end

local function c_rescue(name)
    local player = FuzzyMatchPlayer(name)
    if player then
        GLOBAL.c_goto(player)
        GLOBAL.c_ext()
    end
end

-- Register the functions
GLOBAL.c_ext = c_ext
GLOBAL.c_travel = c_travel
GLOBAL.c_invisible = c_invisible
GLOBAL.c_adminmode = c_adminmode
GLOBAL.c_rescue = c_rescue
GLOBAL.c_freeze = c_freeze
GLOBAL.c_unfreeze = c_unfreeze
GLOBAL.c_freezeall = c_freezeall
GLOBAL.c_unfreezeall = c_unfreezeall
