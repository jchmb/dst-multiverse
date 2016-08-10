--[[local HyperfolderOnBuild = function(builder, prod)
	if prod.prefab == "migration_portal" then
		builder.components.hyperfolder:OnBuild(prod)	
	end
end

local AddHyperfolderComponent = function(player)
	if player.components.hyperfolder ~= nil then
		player:AddComponent("hyperfolder")
		if player.components.builder.onBuild ~= nil then
			oldonBuild = player.components.builder.onBuild
			player.components.builder.onBuild = function(builder, prod)
				oldonBuild(builder, prod)
				HyperfolderOnBuild(builder, prod)
			end
		else
			player.components.builder.onBuild = HyperfolderOnBuild
		end
	end
end--]]