local gray_tasks = {
	"Make a pick gray",
	"Speak to the king gray",
	"Grayness one",
	"Grayness two a",
	"Grayness two b",
	"Grayness three a",
	"Grayness three b",
	"Grayness four a",
	"Grayness four b",
	"The hunters",
}

if HasGorgePort() then
	table.insert(gray_tasks, "Grayness three c")
	table.insert(gray_tasks, "Grayness three d")
end

local set_pieces = {
	["ResurrectionStone"] = { count = 2, tasks=gray_tasks },
	["WormholeGrass"] = { count = 8, tasks=gray_tasks },
	["MooseNest"] = { count = 3, tasks=gray_tasks },
	["CaveEntrance"] = { count = 10, tasks=gray_tasks },
	--["CaveEntrance"] = { count = 7, tasks={"Grayness one", "Grayness two", "Grayness three a", "Grayness three b", "Grayness four", "Make a pick", "Speak to the king gray"} },
}

if HasGorgePort() then
	set_pieces["GorgeSafe2"] =
	{
		count = 5,
		tasks = gray_tasks,
	}
end

AddTaskSetFixed("gray", {
		name = "Grayland",
		location = "forest_gray",
		tasks = gray_tasks,
		numoptionaltasks = 0,
		valid_start_tasks = {
			"Make a pick gray",
		},
		set_pieces = set_pieces,
})
