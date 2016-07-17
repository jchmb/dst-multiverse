local snow_tasks = {
	"Make a pick snowy",
	"Speak to the king snowy",
	"Snowy one",
	"Snowy two a",
	"Snowy two b",
	"Snowy three a",
	"Snowy three b",
	"Snowy four a",
	"Snowy four b",
	"The hunters",
}
 
AddTaskSet("snowy", {
	name = "Snowy",
	location = "forest",
	tasks = snow_tasks,
	numoptionaltasks = 0,
	valid_start_tasks = {
		"Make a pick snowy",
	},
	set_pieces = {
		["ResurrectionStone"] = { count = 2, tasks=snow_tasks},
		["WormholeGrass"] = { count = 8, tasks=snow_tasks },
		--["MooseNest"] = { count = 3, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
		--["MigrationGrass"] = { count = 10, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute", "Befriend the pigs", "Make a Beehat", "The hunters"} },
			--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
	},
})