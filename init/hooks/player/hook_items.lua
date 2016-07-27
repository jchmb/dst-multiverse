HookOnGiveItems = function(world, player)
	local maximum = 10
	local count = math.floor((world.state.cycles + 1) / 4)
	if count > maximum then
		count = maximum
	end
   
		local start_items = {}
		
		--for season starting items
			--for spring
			if world.state.isspring or (world.state.iswinter and world.state.remainingdaysinseason < 3) then
				table.insert(start_items, "umbrella")
			end
			--for summer
			if world.state.issummer or (world.state.isspring and world.state.remainingdaysinseason < 3) then
				table.insert(start_items, "watermelonhat")
			end
			--for winter
			if world.state.iswinter or (world.state.isautumn and world.state.remainingdaysinseason < 3) then
				table.insert(start_items, "earmuffshat")
			end

		--for all season
	local start_item_configs = {
		{name="flint", multiplier=1},
		{name="twigs", multiplier=2},
		{name="cutgrass", multiplier=2},
		{name="log", multiplier=1},
	}

	for k,v in pairs(start_item_configs) do
		local count = math.floor(count * v.multiplier)
		for i = 1, count do
			table.insert(start_items, v.name)
		end
	end

	for k,v in pairs(start_items) do
		local item = GLOBAL.SpawnPrefab(v)
			
		player.components.inventory:GiveItem(item)
	end   
		 
	if player.prev_OnNewSpawn ~= nil then
		player:prev_OnNewSpawn()
		player.prev_OnNewSpawn = nil
	end
end