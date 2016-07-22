local cute_tasks = {
			"Make a pick",
			"Speak to the king cute",
			"Cuteness one",
			"Cuteness two a",
			"Cuteness two b",
			"Cuteness three a",
			"Cuteness three b",
			"Befriend the pigs",
			"Frogs and bugs",
			"Oasis",
			"The hunters",
		}

AddTaskSetFixed("cute", {
		name = "Cute",
		location = "forest",
		tasks = cute_tasks,
		numoptionaltasks = 1,
		optionaltasks = {
			"Kill the spiders",
			"Magic meadow",
		},
		valid_start_tasks = {
			"Make a pick",
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=cute_tasks},
			["WormholeGrass"] = { count = 8, tasks=cute_tasks},
			["MooseNest"] = { count = 3, tasks=cute_tasks},
			["CaveEntrance"] = { count = 10, tasks=cute_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
		},
	})