HookInitCaffeinated = function(player)
	if player.components.caffeinated == nil then
        player:AddComponent("caffeinated")
    end
end