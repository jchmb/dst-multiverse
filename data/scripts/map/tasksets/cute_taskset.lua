local Layouts = GLOBAL.require("map/layouts").Layouts
Layouts["TrapRabbitMeat"] = GLOBAL.require("map/layouts/trap_rabbit_meat")

local cute_tasks = {
			"Make a pick",
			"Speak to the king cute",
			"Cuteness one",
			"Cuteness two a",
			"Cuteness two b",
			"Cuteness three a",
			"Cuteness three b",
			"Cuteness four a",
			"Cuteness four b",
			"Frogs and bugs",
		}

AddTaskSetFixed("cute", {
		name = "Bunnyland",
		location = "forest_bunnyland",
		tasks = cute_tasks,
		numoptionaltasks = 0,
		valid_start_tasks = {
			"Make a pick",
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=cute_tasks},
			["WormholeGrass"] = { count = 8, tasks=cute_tasks},
			["MooseNest"] = { count = 3, tasks=cute_tasks},
			["CaveEntrance"] = { count = 10, tasks=cute_tasks},
			["TrapRabbitMeat"] = {count = 1, tasks=cute_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
		},
	})