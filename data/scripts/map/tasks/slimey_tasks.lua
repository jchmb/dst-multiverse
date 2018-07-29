AddTask("Make a pick slimey", {
		locks=LOCKS.NONE,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
		room_choices={
			["SlimeyForest"] = GetSizeFn(1),
			["SlimeyPlain"] = GetSizeFn(1),
			["SlimeyClearing"] = 1,
		},
		room_bg=GROUND.GRASS,
		background_room="BGSlimey",
		colour={r=0,g=1,b=0,a=1}
	})

AddTask("Speak to the king slimey", {
	locks=LOCKS.NONE,
	keys_given={KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1},
	room_choices={
		["SlimeyPigKingdom"] = 1,
		["SlimeyMagicalDeciduous"] = 2,
		["SlimeyDeepDeciduous"] = 2,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.DECIDUOUS,
	background_room="BGSlimeyDeciduous",
})

AddTask("Slimey one", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["SlimeyForest"] = 2, -- TODO
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MARSH,
	background_room="BGSlimey",
})

AddTask("Slimey two a", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["SlimeySwamp"] = 2,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MARSH,
	background_room="BGSlimey",
})

AddTask("Slimey two b", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["SlimeySwampRocks"] = 2,
		["SlimeyMudRocks"] = 1,
		["SlimeyHerds"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MARSH,
	background_room="BGSlimey",
})

AddTask("Slimey three a", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["SlimeySwampRocks"] = GetSizeFn(1),
		["SlimeyMudRocks"] = GetSizeFn(1),
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MARSH,
	background_room="BGSlimey",
})

AddTask("Slimey three b", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["SlimeyStalagmite"] = 2,
		["SlimeyMudRocks"] = function() return 1 + math.random(GLOBAL.SIZE_VARIATION) end,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MARSH,
	background_room="BGSlimey",
})

AddTask("Slimey four a", {
	locks={LOCKS.TIER4},
	keys_given={KEYS.NONE},
	room_choices={
		["SlimeySpiders"] = 3,
		["SlimeyHounds"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MARSH,
	background_room="BGSlimey",
})

AddTask("Slimey four b", {
	locks={LOCKS.TIER4},
	keys_given={KEYS.CAVE},
	room_choices={
		["SlimeyEwecus"] = 2,
		["SlimeyMermCity"] = 2,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SLIMEY,
	background_room="BGSlimey",
})
