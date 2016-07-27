modimport("init/hooks/player/hook_poisoned.lua")
modimport("init/hooks/player/hook_caffeinated.lua")
modimport("init/hooks/player/hook_items.lua")

local OnEverySpawn = function(src, player)
	HookInitPoisoned(player)
    HookInitCaffeinated(player)
end

local OnPlayerSpawn = function(src, player)
	OnEverySpawn(src, player)
    player.prev_OnNewSpawn = player.OnNewSpawn
    player.OnNewSpawn = function()
        HookOnGiveItems(GLOBAL.TheWorld, player)
	end
end


local function ListenForPlayers(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
    end
end

AddPrefabPostInit("world", ListenForPlayers)
