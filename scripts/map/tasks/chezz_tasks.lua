AddTask("Make a pick chezz", {
	locks=LOCKS.NONE,
	keys_given={KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1},
	room_choices={
		["Marsh"] = 2, 
		["DeepForest"] = 2,
		["ChezzFungusNoiseForest"] = 3,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.CHECKER,
	background_room="BGChezz",
})

AddTask("Chezzness three a", {
	locks={LOCKS.TIER2, LOCKS.GOLD},
	keys_given={KEYS.TIER3},
	room_choices={
		["ChezzLichenMeadow"] = 1,
		["ChezzLichenLand"] = 1,
		["ChezzRocks"] = 1,
	},
	room_bg=GROUND.CHECKER,
	background_room="BGChezz",
	colour={r=.25,g=.28,b=.25,a=.50},
})

AddTask("Chezzness three b", {
	locks={LOCKS.TIER2, LOCKS.PIGS},
	keys_given={KEYS.TIER3},
	room_choices={
		["CuteMonkeyRoom"] = 1,
		["ChezzLichenLand"] = 1,
		["ChezzWetWilds"] = 1,
		["ChezzRocks"] = 1,
	},
	room_bg=GROUND.CHECKER,
	background_room="BGChezz",
	colour={r=.25,g=.28,b=.25,a=.50},
})

AddTask("Chezzness four", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["ChezzLand"] = 3,
		["ChezzLand2"] = 1,
	},
	room_bg=GROUND.CHECKER,
	background_room="BGChezz",
	colour={r=.25,g=.28,b=.25,a=.50},
})

AddTask("Speak to the king chezz", {
	locks={LOCKS.PIGKING,LOCKS.TIER2},
	keys_given={KEYS.PIGS,KEYS.GOLD,KEYS.TIER3},
	room_choices={
		["ChezzPigKingdom"] = 1,
		["ChezzMagicalDeciduous"] = 1,
		["ChezzDeepDeciduous"] = 2,
	}, 
	room_bg=GROUND.BRICK_GLOW,
	background_room="BGChezzDeciduous",
	colour={r=1,g=1,b=0,a=1}
})