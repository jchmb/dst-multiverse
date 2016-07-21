local gray_tasks = {
	"Make a pick gray",
	"Speak to the king gray",
	"Grayness one",
	"Grayness two",
	"Grayness three a",
	"Grayness three b",
	"Grayness four a",
	"Grayness four b",
	"The hunters",
}

AddTaskSet("gray", {
		name = "Gray",
		location = "forest",
		tasks = gray_tasks,
		numoptionaltasks = 0,
		valid_start_tasks = {
			"Make a pick gray",
		},
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=gray_tasks },
			["WormholeGrass"] = { count = 8, tasks=gray_tasks },
			["MooseNest"] = { count = 3, tasks=gray_tasks },
			["MigrationGrass"] = { count = 10, tasks=gray_tasks },
			--["CaveEntrance"] = { count = 7, tasks={"Grayness one", "Grayness two", "Grayness three a", "Grayness three b", "Grayness four", "Make a pick", "Speak to the king gray"} },
		},
})