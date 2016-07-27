local onhit = function(inst, attacker, dmg)
    if attacker ~= nil and attacker:HasTag("poisonous") then
        if math.random() <= 0.5 then
            inst.components.poisoned:SetPoison(-1, 5, 60 * 14)
        end
    end
end

local OnEverySpawn = function(src, player)
	if player.components.poisoned == nil then
		player:AddComponent("poisoned")
        if player.components.combat.onhitfn ~= nil then
            oldonhitfn = player.components.combat.onhitfn
            player.components.combat:SetOnHit(function(inst, attacker, dmg)
                oldonhitfn(inst, attacker, dmg)
                onhit(inst, attacker, dmg)
            end)
        else
            player.components.combat:SetOnHit(onhit)
        end
	end
    if player.components.caffeinated == nil then
        player:AddComponent("caffeinated")
    end
end

local OnPlayerSpawn = function(src, player)
	OnEverySpawn(src, player)
    player.prev_OnNewSpawn = player.OnNewSpawn
    player.OnNewSpawn = function()

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
end


local function ListenForPlayers(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
    end
end

AddPrefabPostInit("world", ListenForPlayers)