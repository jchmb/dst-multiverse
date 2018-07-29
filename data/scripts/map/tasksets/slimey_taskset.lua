local Layouts = GLOBAL.require("map/layouts").Layouts
Layouts["WormTrap"] = GLOBAL.require("map/layouts/worm_trap")

local slimey_tasks = {
			"Make a pick slimey",
			"Speak to the king slimey",
			"Slimey one",
			"Slimey two a",
			"Slimey two b",
			"Slimey three a",
			"Slimey three b",
			"Slimey four a",
			"Slimey four b",
			-- "Magic meadow",
			"ToadStoolTask1",
			"ToadStoolTask2",
			"ToadStoolTask3",
		}

AddTaskSetFixed("slimey", {
		name = "Slimeyland",
		location = "forest_slimey",
		tasks = slimey_tasks,
		numoptionaltasks = 0,
		optionaltasks = {},
		valid_start_tasks = {
			"Make a pick slimey",
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=slimey_tasks},
			["WormholeGrass"] = { count = 8, tasks=slimey_tasks},
			["MooseNest"] = { count = 3, tasks=slimey_tasks },
			["CaveEntrance"] = { count = 10, tasks=slimey_tasks},
			["WormTrap"] = {count = 1, tasks=slimey_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Grayness one", "Grayness two", "Grayness three a", "Grayness three b", "Grayness four", "Make a pick", "Speak to the king gray"} },
		},
	})
