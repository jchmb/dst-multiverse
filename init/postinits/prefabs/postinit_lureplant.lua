if not GLOBAL.TheWorld.ismastersim then
	return
end

AddPrefabPostInit("lureplant", function(inst)
	local tiles = inst.components.minionspawner.validtiletypes
	table.insert(tiles, 50)
	table.insert(tiles, 80)
	table.insert(tiles, 52)
	table.insert(tiles, 57)
end)
