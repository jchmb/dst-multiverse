AddTask("Make a pick fire", {
		locks=LOCKS.NONE,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
		room_choices={
			["FireClearing"] = 1,
			["FireForest3"] = 1,
		},
		room_bg=GROUND.ASH,
		background_room="BGFire",
		colour={r=0,g=1,b=0,a=1}
	})

AddTask("Fire one", {
	locks=LOCKS.NONE,
	keys_given={KEYS.TIER1},
	room_choices={
		["FireBeach"] = GetSizeFn(2),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.BEACH,
	background_room="BGFireBeach",
})

AddTask("Fire two a", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["FireDesert"] = 2,
		["FireDesertHounds"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.DIRT_NOISE,
	background_room="BGFireDesert",
})

AddTask("Fire two b", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["FireBeach3"] = GetSizeFn(1),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.BEACH,
	background_room="BGFireBeach",
})

AddTask("Fire two c", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["FireForest2"] = GetSizeFn(1),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.ASH,
	background_room="BGFire",
})

AddTask("Fire two d", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["FireCoffee"] = GetSizeFn(1),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MAGMA,
	background_room="BGFireCoffee",
})

AddTask("Fire three a", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["FireDragoonLair"] = GetSizeFn(1),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MAGMA,
	background_room="BGFireDragoonLair",
})

AddTask("Fire three b", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["FireJungle"] = GetSizeFn(2),
		["FireMonkeyJungle"] = 3,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.JUNGLE,
	background_room="BGFireJungle",
})

-- AddTask("Fire three b", {
-- 	locks={LOCKS.TIER2},
-- 	keys_given={KEYS.TIER3},
-- 	room_choices={
-- 		["SnowyForest"] = 2,
-- 		["SnowyWalrusForest"] = 1,
-- 		["SnowySpiderForest"] = 2,
-- 		["SnowyKoalefants"] = 1,
-- 	},
-- 	colour={r=.25,g=.28,b=.25,a=.50},
-- 	room_bg=GROUND.SNOWY,
-- 	background_room="BGSnowyForest",
-- })

-- AddTask("Fire four a", {
-- 	locks={LOCKS.TIER3},
-- 	keys_given={KEYS.TIER4},
-- 	room_choices={
-- 		["SnowyForest"] = 1,
-- 		["SnowyIcedLake"] = 5,
-- 		["SnowyIcedLakeHounds"] = 2,
-- 		["SnowyIcedLakeWalrus"] = 1,
-- 	},
-- 	colour={r=.25,g=.28,b=.25,a=.50},
-- 	room_bg=GROUND.SNOWY,
-- 	background_room="BGSnowyIcedLake",
-- })

AddTask("Fire three c", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["FireDesert"] = 1,
		["FireDesertHounds"] = 2,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.DIRT_NOISE,
	background_room="BGFireDesert",
})

AddTask("Fire four b", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["FireDragonflyTerritory"] = GetSizeFn(1),
		["FireDragonflyLair"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.VOLCANO,
	background_room="BGFireDragonflyTerritory",
})

AddTask("Speak to the king fire", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER2},
	room_choices={
		["FirePigKingdom"] = 1,
		["FireMagicalDeciduous"] = 2,
		["FireDeepDeciduous"] = GetSizeFn(1),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.DECIDUOUS,
	background_room="BGFireDeciduous",
})

-- AddTask("Speak to the king snowy", {
-- 	locks={LOCKS.TIER1},
-- 	keys_given={KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER2},
-- 	room_choices={
-- 		["SnowyPigKingdom"] = 1,
-- 		["SnowyMagicalDeciduous"] = 2,
-- 		["SnowyDeepDeciduous"] = 2,
-- 	},
-- 	colour={r=.25,g=.28,b=.25,a=.50},
-- 	room_bg=GROUND.DECIDUOUS,
-- 	background_room="BGSnowyDeciduous",
-- })
