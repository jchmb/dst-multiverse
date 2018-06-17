AddTask("Make a pick chezz", {
	locks=LOCKS.NONE,
	keys_given={KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1},
	room_choices={
		["ChezzClearing"] = 1,
		["ChezzPlain"] = 1,
		["ChezzField"] = GetSizeFn(1)
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
		["ChezzFungusNoiseForest"] = 3,
	},
	room_bg=GROUND.CHECKER,
	background_room="BGChezz",
	colour={r=.25,g=.28,b=.25,a=.50},
})

AddTask("Chezzness three b", {
	locks={LOCKS.TIER2, LOCKS.PIGS},
	keys_given={KEYS.TIER3},
	room_choices={
		["ChezzLichenLand"] = 1,
		["ChezzWetWilds"] = 1,
		["ChezzRocks"] = GetSizeFn(1),
	},
	room_bg=GROUND.CHECKER,
	background_room="BGChezz",
	colour={r=.25,g=.28,b=.25,a=.50},
})

AddTask("Chezzness three c", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["ChezzMetalField"] = GetSizeFn(1),
	},
	room_bg=GROUND.METAL,
	background_room="BGChezzMetalField",
	colour={r=.25,g=.28,b=.25,a=.50},
})

AddTask("Chezzness four", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["ChezzLand"] = GetSizeFn(1),
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
		["ChezzDeepDeciduous"] = GetSizeFn(1),
	},
	room_bg=GROUND.BRICK_GLOW,
	background_room="BGChezzDeciduous",
	colour={r=1,g=1,b=0,a=1}
})
