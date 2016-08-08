AddTask("Make a pick water", {
	locks=LOCKS.NONE,
	keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
	room_choices={
		["WaterClearing"] = 1,
		["BarePlain"] = 1, 
		["Plain"] = 1,
	}, 
	room_bg=GROUND.GRASS_BLUE,
	background_room="BGWater",
	colour={r=0,g=1,b=0,a=1}
})

AddTaskWrapped(
	"Water one",
	LOCKS.NONE,
	{KEYS.TIER1},
	{
		["WaterForest"] = GetSizeFn(1),
		["WaterMeadow"] = 2,
	},
	GROUND.GRASS_BLUE,
	"BGWater"
)

AddTaskWrapped(
	"Water two a",
	{LOCKS.TIER1},
	{KEYS.TIER2},
	{
		["WaterForest"] = 1,
		["WaterRocks"] = GetSizeFn(1),
		["WaterOxHerds"] = 2,
	},
	GROUND.GRASS_BLUE,
	"BGWater"
)

AddTaskWrapped(
	"Water two b",
	{LOCKS.TIER1},
	{KEYS.TIER2},
	{
		["WaterMonkeyForest"] = 2,
		["WaterForest"] = 1,
		["WaterBeaverForest"] = GetSizeFn(1),
	},
	GROUND.GRASS_BLUE,
	"BGWater"
)

AddTaskWrapped(
	"Water three a",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["WaterMeadow"] = GetSizeFn(1),
		["WaterMeadowMerms"] = 2,
	},
	GROUND.GRASS_BLUE,
	"BGWater"
)

AddTaskWrapped(
	"Water three b",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["WaterSpiderForest"] = GetSizeFn(1),
		["WaterMagicalForest"] = 1,
		["WaterEvilForest"] = 1,
	},
	GROUND.FOREST,
	"BGForest"
)

AddBlockedTask(
	"Speak to the king water",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["WaterBeaverKingdom"] = 1,
	},
	GROUND.GRASS_BLUE,
	"BGWater",
	"WaterLureplantWall"
)