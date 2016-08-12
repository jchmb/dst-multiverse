function AddLevelFixed(level_type, data)
	if GetModConfigBoolean("UseDefaultLocations") then
		data.location = "forest"
	end
	AddLevel(level_type, data)
end

function AddTaskSetFixed(task_set, data)
	if GetModConfigBoolean("UseMigrationPortals") then
		data.set_pieces["MigrationGrass"] = data.set_pieces["CaveEntrance"]
		data.set_pieces["CaveEntrance"] = nil
	end
	if GetModConfigBoolean("UseDefaultLocations") then
		data.location = "forest"
	end
	AddTaskSet(task_set, data)
end

function AddTaskSetWrapped(task_set, name, location, tasks, optionaltasks, numoptionaltasks, set_pieces)
	set_pieces = set_pieces or {}
	set_pieces["ResurrectionStone"] = set_pieces["ResurrectionStone"] or {count=2, tasks=tasks}
	set_pieces["WormholeGrass"] = set_pieces["WormholeGrass"] or {count=2, tasks=tasks}
	set_pieces["CaveEntrance"] = set_pieces["CaveEntrance"] or {count=2, tasks=tasks}
	optionaltasks = optionaltasks or nil
	numoptionaltasks = numoptionaltasks or 0
	AddTaskSetFixed(task_set, {
		name = name,
		location = location,
		tasks = tasks,
		optionaltasks = optionaltasks,
		numoptionaltasks = numoptionaltasks,
		valid_start_tasks = {
			"Make a pick " .. task_set,
		},
		set_pieces = set_pieces,
	})
end

function AddLevelWrapped(preset, name, desc, location, task_set, overrides)
	overrides = overrides or {}
	overrides.task_set = task_set
	AddLevelFixed(LEVELTYPE.SURVIVAL, {
	id = preset,
	name=name,
	desc=desc,
	location = location,
	version = 2,
	overrides=overrides,
	numrandom_set_pieces = 5,
	random_set_pieces = {
		"Chessy_1",
		"Chessy_2",
		"Chessy_3",
		"Chessy_4",
		"Chessy_5",
		"Chessy_6",
		"ChessSpot1",
		"ChessSpot2",
		"ChessSpot3",
		"Maxwell1",
		"Maxwell2",
		"Maxwell3",
		"Maxwell4",
		"Maxwell5",
		"Maxwell6",
		"Maxwell7",
		"Warzone_1",
		"Warzone_2",
		"Warzone_3",
	},
})
end

function AddRoomWrapped(room, ground, contents, tags, internal_type)
	tags = tags or {"ExitPiece", "Chester_Eyebone"}
	internal_type = internal_type or nil
	AddRoom(room, {
		colour={r=.25,g=.28,b=.25,a=.50},
		value = ground,
		tags = tags,
		contents = contents,
		internal_type = internal_type,
	})
end

function AddStandardRoom(room, ground, distributepercent, distributeprefabs, countprefabs, countstaticlayouts, prefabdata, internal_type, tags)
	countprefabs = countprefabs or {}
	countstaticlayouts = countstaticlayouts or {}
	prefabdata = prefabdata or {}
	AddRoomWrapped(room, ground, {
		countprefabs = countprefabs,
		distributepercent = distributepercent,
		distributeprefabs = distributeprefabs,
		countstaticlayouts = countstaticlayouts,
		prefabdata = prefabdata,
		internal_type = internal_type,
		tags=tags,
	})
end

function AddCenterRoom(room, ground, distributepercent, distributeprefabs, countprefabs, countstaticlayouts, prefabdata)
	AddStandardRoom(
		room,
		ground,
		distributepercent,
		distributeprefabs,
		countprefabs,
		countstaticlayouts,
		prefabdata,
		GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid
	)	
end

function AddTaskWrapped(task, locks, keys, room_choices, room_bg, background_room)
	AddTask(task, {
		locks=locks,
		keys_given=keys,
		room_choices=room_choices,
		room_bg=room_bg,
		background_room=background_room,
		colour={r=1,g=0.6,b=1,a=1},
	})
end

function AddBlockedTask(task, locks, keys, room_choices, room_bg, background_room, entrance_room)
	AddTask(task, {
		locks=locks,
		keys_given=keys,
		room_choices=room_choices,
		room_bg=room_bg,
		background_room=background_room,
		colour={r=1,g=0.6,b=1,a=1},
		entrance_room=entrance_room,
	})
end

function AddStandardTerrainFilter(prefab)
	GLOBAL.terrain.filter[prefab] = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.SCALE, GROUND.CARPET, GROUND.CHECKER}
end

function AddPlantableTerrainFilter(prefab)
	AddStandardTerrainFilter(prefab)
end

function AddLocationWrapped(label, data)
	AddLocation(data)
	-- if SERVER_LEVEL_LOCATIONS ~= nil then
	-- 	table.insert(SERVER_LEVEL_LOCATIONS, data.location)
	-- end
	GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATION[string.upper(data.location)] = label
	GLOBAL.STRINGS.UI.SANDBOXMENU.LOCATIONTABNAME[string.upper(data.location)] = label
	GLOBAL.STRINGS.TAGS.LOCATION[string.upper(data.location)] = label
end

function GetSizeFn(baseValue)
	return function() return baseValue + math.random(GLOBAL.SIZE_VARIATION) end
end

function GetRandomFn(baseValue, randomValue)
	return function() return baseValue + math.random(0, randomValue) end
end

function MakeSetPieceData(count, tasks)
	return {count=count,tasks=tasks}
end