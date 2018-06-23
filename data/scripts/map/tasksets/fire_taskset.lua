local fire_tasks = {
	"Make a pick fire",
	"Speak to the king fire",
	"Fire one",
	"Fire two a",
	"Fire two b",
	"Fire two c",
	"Fire two d",
	"Fire three a",
	"Fire three b",
	"Fire three c",
	-- "Fire four a",
	"Fire four b",
}

AddTaskSetFixed("fire", {
	name = "Fire",
	location = "forest_fire",
	tasks = fire_tasks,
	numoptionaltasks = 0,
	valid_start_tasks = {
		"Make a pick fire",
	},
	set_pieces = {
		["ResurrectionStone"] = { count = 2, tasks=fire_tasks},
		["WormholeGrass"] = { count = 8, tasks=fire_tasks },
		--["MooseNest"] = { count = 3, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
		["CaveEntrance"] = { count = 10, tasks=fire_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
	},
})
