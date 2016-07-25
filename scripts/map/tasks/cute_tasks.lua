AddTask("Cuteness one", {
	locks={LOCKS.NONE},
	keys_given={KEYS.TIER1},
	room_choices={
		["CuteFriends"] = 1,
		["CuteBunnymanTown"] = 1,
		["BeefalowPlain"] = 1,
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
		["CuteFriends"] = 2,
		["SpiderCity"] = 2,
		["BeefalowPlain"] = 1,
		["CuteBunnymanTown2"] = 1,
		["CuteRocks"] = 1,
		["MandrakeHome"] = 1
	},
	room_bg=GROUND.GRASS,
	background_room="BGGrass",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness two b", {
	locks={LOCKS.TIER1, LOCKS.AXE},
	keys_given={KEYS.TIER2},
	room_choices={
		["CuteFriends"] = 1,
		["SpiderCity"] = 1,
		["BeefalowPlain"] = 1,
		["CuteRocks"] = 2,
		["MandrakeHome"] = 1,
	},
	room_bg=GROUND.GRASS,
	background_room="BGGrass",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness three a", {
	locks={LOCKS.TIER2, LOCKS.AXE},
	keys_given={KEYS.TIER3},
	room_choices={
		["CuteRocks"] = 1,
		["CuteRocks2"] = 2,
		["WalrusHut_Rocky"] = 1,
		["CuteHerds"] = 1,
		["CuteBunnymanTown3"] = 2,
	},
	room_bg=GROUND.DIRT,
	background_room="BGRocky",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Cuteness three b", {
	locks={LOCKS.TIER2, LOCKS.AXE},
	keys_given={KEYS.TIER3},
	room_choices={
		["CuteMonkeyRoom"] = 2,
		["CuteBunnymanTown"] = 1,
		["CuteRocks2"] = 2,
		["WalrusHut_Rocky"] = 1,
		["CuteHerds2"] = 1
	},
	room_bg=GROUND.SAVANNA,
	background_room="BGSavanna",
	colour={r=1,g=0.6,b=1,a=1},
})

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