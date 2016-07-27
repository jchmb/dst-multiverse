AddTask("Make a pick fire", {
		locks=LOCKS.NONE,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
		room_choices={
			["Forest"] = 2,
			["SnowyBarePlain"] = 1,
			["SnowyPlain"] = 2,
			["Clearing"] = 1,
			["FireRocks"] = 1,
			["FireForest2"] = 1,
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
		["SnowyForest"] = 2,
		["SnowyRocks"] = 1,
		["SnowyGraveyard"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowy",
})

AddTask("Fire two a", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["SnowyForest"] = 2,
		["SnowySpiderForest"] = 1,
		["SnowyLeifForest"] = 1,
		["SnowyTallbirdForest"] = 1,
		["SnowyGoats"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowy",
})

AddTask("Fire two b", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["SnowyForest"] = 1,
		["SnowyHerds"] = 1,
		["SnowyLeifForest"] = 1,
		["SnowyTotallyNormalForest"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowy",
})

AddTask("Fire three a", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["SnowyForest"] = 1,
		["SnowyTallbirdForest"] = 2,
		["Marsh"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowyForest",
})

AddTask("Fire three b", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["SnowyForest"] = 2,
		["SnowyWalrusForest"] = 1,
		["SnowySpiderForest"] = 2,
		["SnowyKoalefants"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowyForest",
})

AddTask("Fire four a", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["SnowyForest"] = 1,
		["SnowyIcedLake"] = 5,
		["SnowyIcedLakeHounds"] = 2,
		["SnowyIcedLakeWalrus"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowyIcedLake",
})

AddTask("Fire four b", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["SnowyForest"] = 2,
		["SnowyHoundNest"] = 2,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowyForest",
})

AddTask("Speak to the king snowy", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER2},
	room_choices={
		["SnowyPigKingdom"] = 1,
		["SnowyMagicalDeciduous"] = 2, 
		["SnowyDeepDeciduous"] = 2,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.DECIDUOUS,
	background_room="BGSnowyDeciduous",
})