local Layouts = GLOBAL.require("map/layouts").Layouts
Layouts["TrapRabbitMeat"] = GLOBAL.require("map/layouts/trap_rabbit_meat")
Layouts["BunnymanFarmers"] = GLOBAL.require("map/layouts/bunnyman_farmers")

local cute_tasks = {
		"Make a pick cute",
		"Speak to the king cute",
		"Cuteness one",
		"Cuteness two a",
		"Cuteness two b",
		"Cuteness two e",
		-- "Cuteness two c",
		"Cuteness three a",
		"Cuteness three b",
		"Cuteness three c",
		"Cuteness three d",
		"Cuteness four a",
		"Cuteness four b",
	}

if HasGorgePort() then
	table.insert(cute_tasks, "Cuteness two c")
	table.insert(cute_tasks, "Cuteness two d")
end

local set_pieces =
{
	["ResurrectionStone"] = { count = 4, tasks=cute_tasks},
	["WormholeGrass"] = { count = 8, tasks=cute_tasks},
	["MooseNest"] = { count = 3, tasks=cute_tasks},
	["CaveEntrance"] = { count = 10, tasks=cute_tasks},
	["TrapRabbitMeat"] = {count = 1, tasks=cute_tasks},
	-- ["BunnymanFarmers"] = {count=2, tasks=cute_tasks},
	--["CaveEntrance"] = { count = 7, tasks={"Cuteness one", "Cuteness two a", "Cuteness three a", "Cuteness two b", "Cuteness three b", "Make a pick", "Speak to the king cute"} },
}

if HasGorgePort() then
	set_pieces["GorgeSafe2"] =
	{
		count = 3,
		tasks = cute_tasks,
	}
end

all_tasks = ShallowCopy(cute_tasks)
table.insert(all_tasks, "Cuteness three e")

AddTaskSetFixed("cute", {
		name = "Bunnyland",
		location = "forest_bunnyland",
		tasks = all_tasks,
		numoptionaltasks = 0,
		valid_start_tasks = {
			"Make a pick cute",
		},
		set_pieces = set_pieces,
	})
