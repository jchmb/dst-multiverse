AddTask("Make a pick cute", {
		locks=LOCKS.NONE,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
		room_choices={
			["CuteForest"] = GetSizeFn(1),
			["CutePlain"] = GetSizeFn(1),
			["CuteClearing"] = 1,
		},
		room_bg=GROUND.GRASS,
		background_room="BGGrass",
		colour={r=0,g=1,b=0,a=1}
	})

AddTask("Cuteness one", {
	locks={LOCKS.NONE},
	keys_given={KEYS.TIER1},
	room_choices={
		["CuteFriends"] = 1,
		["CuteBunnymanTown"] = GetSizeFn(1),
		["CuteHerds"] = 1,
		["CuteBunnymanTown2"] = 1,
	},
	room_bg=GROUND.GRASS,
	background_room="BGGrass",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness two a", {
	locks={LOCKS.TIER1, LOCKS.AXE},
	keys_given={KEYS.TIER2},
	room_choices={
		["MandrakeHome"] = 1,
		["CuteBeeClearing"] = GetSizeFn(1),
		["BeeQueenBee"] = 1,
	},
	room_bg=GROUND.GRASS,
	background_room="BGGrass",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness two b", {
	locks={LOCKS.TIER1, LOCKS.AXE},
	keys_given={KEYS.TIER2},
	room_choices={
		["CuteRocks"] = GetSizeFn(2),
		["CuteRocks2"] = 1,
	},
	room_bg=GROUND.ROCKY,
	background_room="BGRocky",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness two e", {
	locks={LOCKS.TIER1, LOCKS.AXE},
	keys_given={KEYS.TIER2},
	room_choices={
		["CutePuffForest"] = GetSizeFn(2),
		["CutePuffForestTown"] = 1,
		["CutePuffForestTown2"] = 2,
		["CutePuffForestTown3"] = 1,
		["CutePuffForestTownBunsy"] = 1,
		["CutePuffForestSpiders"] = 1,
	},
	room_bg=GROUND.GRASS_ORANGE,
	background_room="BGCutePuffForest",
	colour={r=1,g=0.6,b=1,a=1},
})

-- AddTask("Cuteness two c", {
-- 	locks={LOCKS.TIER1, LOCKS.AXE},
-- 	keys_given={KEYS.TIER2},
-- 	room_choices={
-- 		["CuteSapTreeForest"] = GetSizeFn(1),
-- 		["CuteSapTreeForestCore"] = 1,
-- 	},
-- 	room_bg=GROUND.QUAGMIRE_PARKFIELD,
-- 	background_room="BGCuteSapTreeForest",
-- 	colour={r=1,g=0.6,b=1,a=1},
-- })

AddTask("Cuteness three a", {
	locks={LOCKS.TIER2, LOCKS.AXE},
	keys_given={KEYS.TIER3},
	room_choices={
		["WalrusHut_Rocky"] = 1,
		["CuteBunnymanTown4"] = 1,
		["CuteHerds"] = GetSizeFn(1),
	},
	room_bg=GROUND.DIRT,
	background_room="BGRocky",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness three b", {
	locks={LOCKS.TIER2, LOCKS.AXE},
	keys_given={KEYS.TIER3},
	room_choices={
		["CuteDesert"] = GetSizeFn(1),
		["CuteDesertHounds"] = 2,
	},
	room_bg=GROUND.DIRT_NOISE,
	background_room="BGBadlands",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTaskWrapped(
	"Cuteness three c",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["CuteSwamp"] = GetSizeFn(1),
		["CuteSwampMutants"] = 2,
	},
	GROUND.MARSH,
	"BGCuteSwamp"
)

AddTaskWrapped(
	"Cuteness three d",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["CuteCarrodoyForest"] = GetSizeFn(1),
		["CuteCarrodoyForestCore"] = 2,
		["CuteCarrodoyForestRabbits"] = 1,
	},
	GROUND.GRASS_ORANGE,
	"BGCuteCarrodoyForest"
)

AddTaskWrapped(
	"Cuteness three e",
	{LOCKS.TIER2},
	{KEYS.TIER3},
	{
		["CuteGraveyard"] = GetSizeFn(1),
		["CuteGraveyardFrabbit"] = 1,
	},
	GROUND.FOREST,
	"BGCuteGraveyard"
)

AddTaskWrapped(
	"Cuteness four a",
	{LOCKS.TIER3},
	{KEYS.TIER4},
	{
		["CuteSpiderForest"] = GetSizeFn(1),
		["SpiderCity"] = 1,
	},
	GROUND.FUNGUS,
	"BGCuteFungus"
)

AddTaskWrapped(
	"Cuteness four b",
	{LOCKS.TIER3},
	{KEYS.TIER4},
	{
		["CuteGiantBunnyLair"] = 1,
		["CuteBunnymanTown3"] = 1,
		["CuteBunnymanTown5"] = GetSizeFn(1),
	},
	GROUND.FUNGUS,
	"BGCuteFungus"
)

AddBlockedTask(
	"Cuteness four d",
	{LOCKS.TIER5},
	{KEYS.TIER6},
	{
		["CuteBeach"] = GetSizeFn(1),
		["CuteBeachPirates"] = 2,
	},
	GROUND.SAND,
	"BGCuteBeach",
	"CuteBeachEntrance"
)

AddTask("Speak to the king cute", {
	locks={LOCKS.PIGKING,LOCKS.TIER2},
	keys_given={KEYS.PIGS,KEYS.GOLD,KEYS.TIER3},
	room_choices={
		["PigKingdom"] = 1,
		["CuteMagicalDeciduous"] = 1,
		["CuteDeepDeciduous"] = 2,
	},
	room_bg=GROUND.GRASS,
	background_room="BGCuteDeciduous",
	colour={r=1,g=1,b=0,a=1}
})

if HasGorgePort() then
	AddTask("Cuteness two c", {
		locks={LOCKS.TIER1, LOCKS.AXE},
		keys_given={KEYS.TIER2},
		room_choices={
			["CuteSapTreeForest"] = GetSizeFn(1),
			["CuteSapTreeForestTraders"] = 1,
			["CuteSapTreeForestCore"] = 1,
		},
		room_bg=GROUND.QUAGMIRE_PARKFIELD,
		background_room="BGCuteSapTreeForest",
		colour={r=1,g=0.6,b=1,a=1},
	})

	AddTask("Cuteness two d", {
		locks={LOCKS.TIER1, LOCKS.AXE},
		keys_given={KEYS.TIER2},
		room_choices={
			["CuteSapTreeForest"] = GetSizeFn(1),
			["CuteSapTreeForestTraders2"] = 1,
		},
		room_bg=GROUND.QUAGMIRE_PARKFIELD,
		background_room="BGCuteSapTreeForest",
		colour={r=1,g=0.6,b=1,a=1},
	})

end
