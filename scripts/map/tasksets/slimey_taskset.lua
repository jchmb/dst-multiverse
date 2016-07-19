local slimey_tasks = {
			"Make a pick",
			"Speak to the king slimey",
			"Slimey one",
			"Slimey two a",
			"Slimey two b",
			"Slimey three a",
			"Slimey three b",
			"Slimey four a",
			"Slimey four b",
			"Frogs and bugs",
		}

AddTaskSet("slimey", {
		name = "Slimey",
		location = "forest_slimey",
		tasks = slimey_tasks,
		numoptionaltasks = 1,
		optionaltasks = {
			"Befriend the pigs",
			"Magic meadow",
		},
		valid_start_tasks = {
			"Make a pick",
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=slimey_tasks},
			["WormholeGrass"] = { count = 8, tasks=slimey_tasks},
			["MooseNest"] = { count = 3, tasks=slimey_tasks },
			["MigrationGrass"] = { count = 10, tasks=slimey_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Grayness one", "Grayness two", "Grayness three a", "Grayness three b", "Grayness four", "Make a pick", "Speak to the king gray"} },
		},
	})