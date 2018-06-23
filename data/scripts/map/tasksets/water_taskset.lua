local Layouts = GLOBAL.require("map/layouts").Layouts
Layouts["FrograinTrap"] = GLOBAL.require("map/layouts/trap_frograin")
local tasks = {
		"Make a pick water",
		"Water one",
		"Water two a",
		"Water two b",
		-- "Water two c",
		"Water three a",
		"Water three b",
		"Water three c",
		-- "Water three d",
		"Water three e",
		"Water four a",
		"Water four b",
		"Speak to the king water",
	}

local normaltasks = {
	"Make a pick water",
	"Water one",
	"Water two a",
	"Water two b",
	"Water two c",
	"Water three a",
	"Water three b",
	"Water three c",
	-- "Water three d",
}

AddTaskSetWrapped(
	"water",
	"Beaverland",
	"forest_water",
	tasks,
	{},
	0,
	{
		["FrograinTrap"] = MakeSetPieceData(1, tasks),
		["WormholeGrass"] = MakeSetPieceData(8, normaltasks),
		["ResurrectionStone"] = MakeSetPieceData(2, normaltasks),
		["CaveEntrance"] = MakeSetPieceData(8, normaltasks),
	}
)
