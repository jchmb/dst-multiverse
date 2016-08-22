modimport("init/hooks/player/hook_poisonable")
modimport("init/hooks/player/hook_caffeinated")
modimport("init/hooks/player/hook_mimi")
modimport("init/hooks/player/hook_starting_items")

local OnEverySpawn = function(src, player)
	--HookInitPoisonable(player)
    HookInitCaffeinated(player)
    --HookInitMimi(player)
end

local OnPlayerSpawn = function(src, player)
	OnEverySpawn(src, player)
    player.prev_OnNewSpawn = player.OnNewSpawn
    player.OnNewSpawn = function()
        if GetModConfigBoolean("EnableStartingItems") then
            HookInitStartingItems(player)
        end
        if player.prev_OnNewSpawn ~= nil then
            player:prev_OnNewSpawn()
            player.prev_OnNewSpawn = nil
        end
    end
end


local function ListenForPlayers(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
    end
end

AddPrefabPostInit("world", ListenForPlayers)
