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
	{KEYS.TIER2, KEYS.TIER5},
	{
		["WaterForest"] = 1,
		["WaterBeaverForest"] = GetSizeFn(1),
		["WaterBeaverForestHotspot"] = 1,
	},
	GROUND.GRASS_BLUE,
	"BGWater"
)

-- AddTaskWrapped(
-- 	"Water two c",
-- 	{LOCKS.TIER1},
-- 	{LOCKS.TIER2},
-- 	{
-- 		["WaterMonkeyJungle"] = 2,
-- 		["WaterSpiderJungle"] = 2,
-- 		["WaterJungle"] = GetSizeFn(1),
-- 	},
-- 	GROUND.JUNGLE,
-- 	"BGWaterJungle"
-- )

AddTaskWrapped(
	"Water three a",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["WaterMeadow"] = GetSizeFn(1),
		["WaterMeadowMerms"] = 1,
		["WaterBeeQueen"] = 1,
		["WaterBeeClearing"] = 1,
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

AddTaskWrapped(
	"Water three c",
	{LOCKS.TIER2},
	{LOCKS.TIER3},
	{
		["WaterSuperMeadow"] = GetSizeFn(1),
		["WaterWalrusMeadow"] = 1,
	},
	GROUND.GRASS_BLUE,
	"BGWater"
)

AddBlockedTask(
	"Water three d",
	{LOCKS.TIER2, LOCKS.TIER5},
	{LOCKS.TIER3},
	{
		["WaterBeach"] = GetSizeFn(1),
		["WaterBeachRocks"] = 1,
		["WaterBeachSharkittens"] = 1,
	},
	GROUND.SAND,
	"BGWaterBeach",
	"WaterBeachEntrance"
)

AddTaskWrapped(
	"Water three e",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["WaterMeanvers"] = GetSizeFn(1),
	},
	GROUND.GRASS_BROWN,
	"BGWaterMeanvers"
)

AddBlockedTask(
	"Water four a",
	{LOCKS.TIER3},
	{KEYS.TIER4},
	{
		["WaterMooseLairTreasure"] = 1,
	},
	GROUND.GRASS_BLUE,
	"BGWater",
	"WaterMooseLair"
)

AddBlockedTask(
	"Water four b",
	{LOCKS.TIER3},
	{KEYS.TIER4},
	{
		["WaterMarsh"] = GetSizeFn(1),
		["WaterMarshTreasure"] = 1,
	},
	GROUND.MARSH,
	"BGWaterMarsh",
	"WaterMarshSnakes"
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
