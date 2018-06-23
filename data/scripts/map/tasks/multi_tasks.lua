AddTask("Make a pick multi", {
	locks=LOCKS.NONE,
	keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
	room_choices={
		["MultiBeachClearing"] = 1,
		["MultiBeach"] = GetSizeFn(1),
	},
	room_bg=GROUND.SAND,
	background_room="BGMultiBeach",
	colour={r=0,g=1,b=0,a=1}
})

AddTaskWrapped(
	"Multi one a",
	{LOCKS.TIER1},
	{KEYS.TIER2},
	{
		["CuteBunnymanTown3"] = 1,
		["CuteBunnymanTown5"] = 1,
		["CuteBunnymanTown2"] = 1,
		["CuteBunnymanTown"] = 1,
		["MultiHerds"] = GetSizeFn(1),
	},
	GROUND.FUNGUS,
	"BGCuteFungus"
)

AddTaskWrapped(
	"Multi one b",
	{LOCKS.TIER1},
	{KEYS.TIER2},
	{
		["SnowyForest"] = GetSizeFn(1),
		["SnowyLeifForest"] = 1,
		["SnowyGoats"] = 1,
	},
	GROUND.SNOWY,
	"BGSnowy"
)

AddTaskWrapped(
	"Multi one c",
	{LOCKS.TIER1},
	{KEYS.TIER2},
	{
		["MultiRocks"] = GetSizeFn(1),
	},
	GROUND.ROCKY,
	"BGMultiRocks"
)
