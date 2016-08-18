HookInitPoisonable = function(player)
    if player.components.poisonable == nil then
		player:AddComponent("poisonable")
	end
end