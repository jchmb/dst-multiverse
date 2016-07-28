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

function AddTaskSetWrapped(task_set, name, location, tasks)
	AddTaskSetFixed(task_set, {
		name = name,
		location = location,
		tasks = tasks,
		numoptionaltasks = 0,
		valid_start_tasks = {
			"Make a pick " .. task_set,
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=tasks},
			["WormholeGrass"] = { count = 8, tasks=tasks},
			["MooseNest"] = { count = 6, tasks=tasks},
			["CaveEntrance"] = { count = 10, tasks=tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
		},
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

function AddRoomWrapped(room, ground, contents, tags)
	tags = tags or {"ExitPiece", "Chester_Eyebone"}
	AddRoom(room, {
		colour={r=.25,g=.28,b=.25,a=.50},
		value = ground,
		tags = tags,
		contents = contents,
	})
end

function AddStandardRoom(room, ground, distributepercent, distributeprefabs, countprefabs)
	countprefabs = countprefabs or {}
	AddRoomWrapped(room, ground, {
		countprefabs = countprefabs,
		distributepercent = distributepercent,
		distributeprefabs = distributeprefabs,
	})
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