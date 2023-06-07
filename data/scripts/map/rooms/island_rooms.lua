AddRoom("BG Slimey Island", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SLIMEY,
	tags = {"ExitPiece"},
    contents = {
        distributepercent = 0.15,
        distributeprefabs = {
            yellow_mushroom = 0.01,
            bittersweetbush = 0.01,
            rock_slimey = 0.04,
            rock2 = 0.001,
            mucus = 0.01,
            phlegm = 0.01,
            perma_grassgekko = 0.01,
        }
    }
})

AddRoom("Slimey Island Pig Village", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SLIMEY,
	tags = {"Town"},
    required_prefabs = {"pigking_slimey"},
    contents = {
        countstaticlayouts={
			["PigKingSlimey"] = 1,
        },
        distributepercent = 0.25,
        distributeprefabs = {
            yellow_mushroom = 0.03,
            bittersweetbush = 0.03,
            grass = 0.02,
        },
        countprefabs = {
            pighouse_yellow = GetRandomFn(6, 3),
            pillar_algae = GetRandomFn(2, 3),
        },
    }
})

AddRoom("Slimey Island Swamp", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SLIMEY,
	tags = {"ExitPiece"},
    contents = {
        distributepercent = 0.3,
        distributeprefabs = {
            yellow_mushroom = 0.01,
            reeds = 0.02,
        },
        countprefabs = {
            perma_pond_mos = GetRandomFn(4, 4),
        },
    }
})

-- Snowy Island
AddRoom("BG Snowy Island", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SNOWY,
	tags = {"ExitPiece"},
    contents = {
        distributepercent = 0.22,
        distributeprefabs = {
		    evergreen = 2,
            red_mushroom = 0.01,
            green_mushroom = 0.01,
            blue_mushroom = 0.01,
            mintybush = 0.01,
            rock_ice = 0.05,
            sapling = 0.01,
            grass = 0.01,
            flint = 0.01,
            rocks = 0.01,
        }
    }
})

AddRoom("Snowy Island Walrus Camp", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SNOWY,
	tags = {"ExitPiece"},
    contents = {
        distributepercent = 0.35,
        distributeprefabs = {
            evergreen = 2,
            red_mushroom = 0.01,
            green_mushroom = 0.01,
            blue_mushroom = 0.01,
            rock_ice = 0.02,
            sapling = 0.01,
            grass = 0.01,
        },
        countprefabs = {
            perma_walrus_camp = GetRandomFn(1, 2),
            pond_open = GetRandomFn(1, 2),
        },
    }
})

AddRoom("Snowy Island Yeti", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SNOWY,
	tags = {"ExitPiece"},
    contents = {
        distributepercent = 0.6,
        distributeprefabs = {
            evergreen = 7,
            red_mushroom = 0.01,
            green_mushroom = 0.01,
            blue_mushroom = 0.01,
            rock_ice = 0.02,
            sapling = 0.01,
            grass = 0.01,
        },
        countprefabs = {
            yeti = GetRandomFn(2, 3),
        },
    }
})

AddRoom("Snowy Island Bunny Village", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SNOWY,
	tags = {"ExitPiece"},
    contents = {
        distributepercent = 0.3,
        distributeprefabs = {
		    evergreen = 4,
            red_mushroom = 0.01,
            green_mushroom = 0.01,
            blue_mushroom = 0.01,
            mintybush = 0.02,
            rock_ice = 0.01,
            sapling = 0.01,
            grass = 0.02,
            rock1 = 0.005,
        },
        countprefabs = {
            rabbithouse_snow = GetRandomFn(5, 3),
            carrot_planted = GetRandomFn(30, 10),
            fireflies = GetRandomFn(30, 20),
            rabbithole = GetRandomFn(7, 3),
        },
    }
})

AddRoom("Snowy Island Pig Village", {
    colour={r=.25,g=.28,b=.25,a=.50},
	value = WORLD_TILES.SNOWY,
	tags = {"Town"},
    contents = {
        distributepercent = 0.3,
        required_prefabs = {"pigking_blue"},
        countstaticlayouts={
			["PigKingBlue"] = 1,
        },
        distributeprefabs = {
		    evergreen = 4,
            red_mushroom = 0.01,
            green_mushroom = 0.01,
            blue_mushroom = 0.01,
            mintybush = 0.02,
            sapling = 0.01,
            grass = 0.01,
        },
        countprefabs = {
            pighouse_blue = GetRandomFn(5, 3),
            fireflies = GetRandomFn(10, 10),
            catcoonden = 1,
        },
    }
})