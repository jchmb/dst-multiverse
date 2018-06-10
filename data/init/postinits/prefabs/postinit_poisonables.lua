AddPrefabPostInitAny(function(inst)
	-- Only fightable mobs can be poisonable
	if inst.components.combat and inst.components.health and inst.components.poisonable == nil then
		inst:AddComponent("poisonable")
	end
end)
