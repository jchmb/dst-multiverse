AddPrefabPostInit("lureplant", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		local tiles = inst.components.minionspawner.validtiletypes
		table.insert(tiles, 50)
		table.insert(tiles, 80)
		table.insert(tiles, 52)
		table.insert(tiles, 57)
	end
end)
