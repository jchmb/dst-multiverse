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

AddRoom("BGSlimey", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MUD,
	tags = {"ExitPiece", "Chester_Eyebone"},
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
		}
	}
})

AddRoom("BGSlimeyDeciduous", {
	colour={r=.1,g=.8,b=.1,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
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

			green_mushroom = 0.4,

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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .3,
		distributeprefabs={
			deciduoustree = 3,

			sapling=0.03,

			green_mushroom = 4,

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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .4,	
		distributeprefabs={
			sapling=0.05,

			deciduoustree = 10,

			blue_mushroom = 0.1,
			green_mushroom = 0.7,

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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			meteorspawner = 2,
			migration_portal = 1,
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
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
	tags = {"ExitPiece", "Chester_Eyebone"},
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
	countprefabs = {
		houndmound = 2,
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
	countprefabs = {
		mermhouse = 5,
		thulecite_pieces = 3,
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
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
	countprefabs = {
		spat = 2,
		thulecite_pieces = 2,
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
