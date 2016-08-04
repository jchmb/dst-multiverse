local chezz_tasks = {
			"Make a pick chezz",
			"Dig that rock",
			"Speak to the king chezz",
			"Chezzness three a",
			"Chezzness three b",
			"Chezzness four",
			"Kill the spiders",
			"Killer bees!",
			"The hunters",
			"Squeltch",
			"Beeeees!",
		}

AddTaskSetFixed("chezz", {
		name = "Chessland",
		location = "forest",
		tasks = chezz_tasks,
		numoptionaltasks = 1,
		optionaltasks = {
			"Frogs and bugs",
			"Oasis",
		},
		valid_start_tasks = {
			"Make a pick chezz",
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 1, tasks=chezz_tasks},
			["WormholeGrass"] = { count = 8, tasks=chezz_tasks},
			["CaveEntrance"] = { count = 10, tasks=chezz_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Grayness one", "Grayness two", "Grayness three a", "Grayness three b", "Grayness four", "Make a pick", "Speak to the king gray"} },
		},
	})