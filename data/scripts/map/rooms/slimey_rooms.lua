local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
Layouts["PigKingSlimey"] = StaticLayout.Get(
	"map/static_layouts/default_pigking_slimey",
	{
		start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		layout_position = GLOBAL.LAYOUT_POSITION.CENTER
	}
)

AddStandardRoom(
	"SlimeyClearing",
	GROUND.FOREST,
	0.1,
	{
        fireflies = 1,

        grass = .15,
        sapling=.9,
		twiggytree = 0.9,
		ground_twigs = 0.06,
        berrybush=.1,
        berrybush_juicy = 0.05,
        red_mushroom = .01,
        green_mushroom = .02,
	},
	{
		spawnpoint_multiplayer = 1,
		-- homesign_welcome = 1,
	},
	{},
	{},
	nil,
	{"ExitPiece", "Hutch_Fishbowl", "StagehandGarden"}
)

AddStandardRoom(
	"SlimeyForest",
	GROUND.FOREST,
	0.3,
	{
        fireflies = 0.2,
		--evergreen = 6,
		rock_petrified_tree = 0.015,
        rock1 = 0.05,
        grass = .05,
        sapling=.8,
		twiggytree = 0.8,
		ground_twigs = 0.06,
		--rabbithole=.05,
        berrybush=.03,
        berrybush_juicy = 0.015,
        carrot_planted = 0.1,
        red_mushroom = .03,
        green_mushroom = .02,
		trees = {weight = 3, prefabs = {"evergreen", "evergreen_sparse"}},
	},
	{},
	{},
	{},
	nil,
	{"ExitPiece", "Hutch_Fishbowl"}
)

AddStandardRoom(
	"SlimeyPlain",
	GROUND.SAVANNA,
	0.3,
	{
    	rock_petrified_tree = 0.2,
        rock1 = 0.075,
        perma_grass = 0.5,
        rabbithole= 0.3,
        green_mushroom = .005,
        carrot_planted = 0.05,
	},
	{},
	{},
	{},
	nil,
	{"ExitPiece", "Hutch_Fishbowl"}
)

AddRoom("BGSlimey", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MUD,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			marsh_bush = 0.2,
			marsh_tree = 0.05,
			reeds = 0.03,
			perma_pond_mos = 0.1,
			bittersweetbush = 0.1,
			carrot_planted = 0.05,
			sapling = 0.2,
			twiggytree = 0.2,
			perma_grassgekko = 0.1,
			mucus = 0.1,
			phlegm = 0.01,
			snake_hole = 0.1,
			flint = 0.02,
		}
	}
})

AddRoom("BGSlimeyDeciduous", {
	colour={r=.1,g=.8,b=.1,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = .2,
		distributeprefabs={
			deciduoustree = 4,

			pighouse_yellow=.1,

			rock_slimey=0.1,
			rock2=0.05,

			sapling=0.05,
			perma_grassgekko=0.2,

			flower=1,

			yellow_mushroom = 0.4,

			bittersweetbush=0.05,
			carrot_planted = 0.2,

			fireflies = 1.5,

			perma_pond_mos=.01,

			slurtlehole = 0.1,
		},
	}
})

AddRoom("SlimeyMagicalDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = .3,
		distributeprefabs={
			deciduoustree = 3,

			sapling=0.03,

			yellow_mushroom = 4,

			fireflies = 2,
			flower=5,

			molehill = 1,

			bittersweetbush = 3,

			perma_pond_mos = 0.15,
			slurtlehole = 0.1,
			pighouse_yellow = 0.05,
		},
	}
})

AddRoom("SlimeyDeepDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = .4,
		distributeprefabs={
			sapling=0.05,

			deciduoustree = 10,

			yellow_mushroom = 0.5,

			fireflies = 3,
			slurtlehole = 0.2,

			perma_grassgekko = 0.1,

			pighouse_yellow = 0.05,
		},
	}
})

AddRoom("SlimeyPigKingdom", {
	colour={r=0.8,g=.8,b=.1,a=.50},
	value = GROUND.SLIMEY,
	tags = {"Town"},
	required_prefabs = {"pigking_slimey"},
	contents =  {
		countstaticlayouts={
			["PigKingSlimey"]=1,
			["CropCircle"]=function() return math.random(0,1) end,
			["TreeFarm"]= 	function()
								if math.random() > 0.97 then
									return math.random(1,2)
								end
								return 0
							end,
		},
		countprefabs= {
			pighouse_yellow = function () return 5 + math.random(4) end,
		}
	}
})

AddRoom("SlimeySwamp", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MARSH,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			marsh_bush = 0.2,
			marsh_tree = 0.05,
			mermhouse = 0.05,
			tentacle = 0.5,
			reeds = 0.15,
			perma_pond_mos = 0.1,
			mound = 0.2,
		}
	}
})

AddRoom("SlimeySwampRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		countprefabs = {
			meteorspawner = 2,
		},
		distributepercent = 0.10,
		distributeprefabs = {
			marsh_bush = 0.2,
			marsh_tree = 0.05,
			rock_slimey = 0.2,
			rock2 = 0.1,
			reeds = 0.05,
			perma_pond_mos = 0.1,
			perma_grassgekko = 0.1,
			rock_ice = 0.05,
			snake_hole = 0.08,
		}
	}
})

AddRoom("SlimeyMudRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			rock_slimey = 0.1,
			rock2 = 0.1,
			perma_pond_mos = 0.1,
			perma_grassgekko = 0.1,
			spiderden_poisonous = 0.1,
			slurtlehole = 0.1,
			rock_ice = 0.1,
			pighouse_yellow = 0.075,
		},
		countprefabs = {
			pillar_algae = GetRandomFn(2, 3),
		},
	}
})

AddRoom("SlimeyHerds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			perma_grassgekko = 0.1,
			beefalo = 0.1,
			perma_grass = 0.1,
			marsh_bush = 0.2,
			sapling = 0.1,
			twiggytree = 0.1,
			flint = 0.05,
			perma_pond_mos = 0.05,
		},
		countprefabs = {
			pillar_algae = GetRandomFn(2, 3),
		},
	}
})

AddRoom("SlimeyStalagmite", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.UNDERROCK,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
        distributepercent = .15,
        distributeprefabs=
        {
        stalagmite = 0.2,
        spiderden_poisonous = 0.05,
		fern = 0.5,
		slurtlehole = 0.1,
		perma_grassgekko = 0.1,
		pighouse_yellow = 0.05,
        },
    }
})

AddRoom("SlimeySpiders", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MUD,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
		countprefabs = {
			thulecite_pieces = 1,
		},
        distributepercent = .2,
        distributeprefabs=
        {
        	spiderden_poisonous = 0.1,
			marsh_bush = 0.5,
			marsh_tree = 0.2,
			bittersweetbush = 0.1,
			mucus = 0.05,
			phlegm = 0.05,
        },
    }
})

AddRoom("SlimeyHounds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
	countprefabs = {
		houndmound_slimey = 2,
	},
        distributepercent = .2,
        distributeprefabs=
        {
		rocks = 0.1,
		flint = 0.1,
		marsh_bush = 0.5,
        },
    }
})

AddRoom("SlimeyMermCity", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MARSH,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
	countprefabs = {
		mermhouse = 5,
        },
        distributepercent = .2,
        distributeprefabs=
        {
		marsh_bush = 0.5,
		reeds = 0.3,
        },
    }
})

AddRoom("SlimeyEwecus", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
	tags = {"ExitPiece", "Hutch_Fishbowl"},
	contents =  {
	countprefabs = {
		spat = 2,
		phlegm = 5,
        },
        distributepercent = .2,
        distributeprefabs=
        {
		marsh_tree = 3,
		perma_pond_mos = 0.1,
		reeds = 0.1,
        },
    }
})
