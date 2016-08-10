local snow_tasks = {
	"Make a pick snowy",
	"Speak to the king snowy",
	"Snowy one",
	"Snowy two a",
	"Snowy two b",
	"Snowy three a",
	"Snowy three b",
	"Snowy three c",
	"Snowy four a",
	"Snowy four b",
}
 
AddTaskSetFixed("snowy", {
	name = "Snowland",
	location = "forest_snow",
	tasks = snow_tasks,
	numoptionaltasks = 0,
	valid_start_tasks = {
		"Make a pick snowy",
	},
	set_pieces = {
		["ResurrectionStone"] = { count = 2, tasks=snow_tasks},
		["WormholeGrass"] = { count = 8, tasks=snow_tasks },
		--["MooseNest"] = { count = 3, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
		["CaveEntrance"] = { count = 10, tasks=snow_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
	},
})