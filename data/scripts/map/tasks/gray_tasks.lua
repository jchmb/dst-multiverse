AddTask("Grayness one", {
	locks={LOCKS.NONE},
	keys_given={KEYS.TIER1},
	room_choices={
		["GrayEvilMoles"] = 2,
		["GrayPetGraveyard"] = 2,
	},
	room_bg=GROUND.FOREST,
	background_room="BGGray",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Grayness two a", {
	locks={KEYS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["GrayPetGraveyard"] = 1,
		["GraySpiderTown"] = 2,
		["GrayHerdsBeefalo"] = 1,
	},
	room_bg=GROUND.FOREST,
	background_room="BGGray",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Grayness two b", {
	locks={KEYS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["GrayMoonRocks"] = GetSizeFn(1),
		["GrayGoats"] = 1,
		["GrayBeardlords"] = 1,
	},
	room_bg=GROUND.ASH,
	background_room="BGGray2",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Grayness three a", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["GraySpiderTown"] = 1,
		["GrayHerds"] = 1,
		["GraySwamp"] = 1,
	},
	room_bg=GROUND.DIRT,
	background_room="BGGray",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Grayness three b", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["GraySpiderTown"] = 1,
		["GrayHoundTown"] = 1,
		["GrayHerds"] = 1,
		["GrayRocks"] = GetSizeFn(1),
	},
	room_bg=GROUND.ROCKY,
	background_room="BGGray",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Grayness four a", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["GrayMermRocks"] = 1,
		["GrayMermRocksSaltPonds"] = GetSizeFn(1),
		["GrayCaveSpiders"] = 1,
	},
	room_bg=GROUND.ASH,
	background_room="BGGray2",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Grayness four b", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["GrayHoundTown"] = 1,
		["GrayHoundTownVarg"] = 1,
		["GrayCaveSpiders"] = 1,
	},
	room_bg=GROUND.ASH,
	background_room="BGGray2",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Speak to the king gray", {
	locks={LOCKS.PIGKING,LOCKS.TIER2},
	keys_given={KEYS.PIGS,KEYS.TIER3},
	room_choices={
		["GrayPigKingdom"] = 1,
		["GrayMagicalDeciduous"] = 1,
		["GrayDeepDeciduous"] = 3,
	},
	room_bg=GROUND.GRASS,
	background_room="BGGrayDeciduous",
	colour={r=1,g=1,b=0,a=1}
})

AddTask("Make a pick gray", {
		locks=LOCKS.NONE,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
		room_choices={
			["GrayForest"] = 2,
			["BarePlain"] = 1,
			["Plain"] = 1,
		},
		room_bg=GROUND.GRASS_GRAY,
		background_room="BGGray",
		colour={r=0,g=1,b=0,a=1}
	})

if HasGorgePort() then
	AddTask("Grayness three c", {
		locks={LOCKS.TIER2},
		keys_given={KEYS.TIER3},
		room_choices={
			["ParkStone"] = GetSizeFn(1),
			["ParkStoneTraders"] = 1,
			["ParkStoneCrabs"] = 1,
		},
		room_bg=GROUND.QUAGMIRE_PARKSTONE,
		background_room="BGParkStone",
		colour={r=0,g=1,b=0,a=1}
	})

	AddTask("Grayness three d", {
		locks={LOCKS.TIER2},
		keys_given={KEYS.TIER3},
			room_choices={
				["GorgeSwamp"] = GetSizeFn(3),
				["GorgeSwampElder"] = 1,
			},
			room_bg=GROUND.QUAGMIRE_PEATFOREST,
			background_room="BGGorgeSwamp",
			colour={r=0,g=1,b=0,a=1}
		})
end
