HookInitStartingItems = function(player)
	local maximum = 10
		local count = math.floor((GLOBAL.TheWorld.state.cycles + 1) / 5)
		if count > maximum then
			count = maximum
		end

		local start_items = {}

		--for season starting items
		if true then
			--for spring
			if GLOBAL.TheWorld.state.isspring or (GLOBAL.TheWorld.state.iswinter and GLOBAL.TheWorld.state.remainingdaysinseason < 3) then
				table.insert(start_items, "umbrella")
			end
			--for summer
			if GLOBAL.TheWorld.state.issummer or (GLOBAL.TheWorld.state.isspring and GLOBAL.TheWorld.state.remainingdaysinseason < 3) then
				table.insert(start_items, "watermelonhat")
			end
			--for winter
			if GLOBAL.TheWorld.state.iswinter or (GLOBAL.TheWorld.state.isautumn and GLOBAL.TheWorld.state.remainingdaysinseason < 3) then
				table.insert(start_items, "earmuffshat")
			end
		end

		--for all season
		local start_item_configs = {
			{name="flint", multiplier=2},
			{name="twigs", multiplier=3},
			{name="cutgrass", multiplier=3},
			{name="log", multiplier=2},
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
