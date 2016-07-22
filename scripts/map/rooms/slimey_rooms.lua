AddRoom("BGSlimey", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MARSH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			marsh_bush = 0.2,
			marsh_tree = 0.05,
			reeds = 0.03,
			pond_mos = 0.1,
			spiderden = 0.01,
			berrybush = 0.1,
			berrybush_juicy = 0.05,
			carrot_planted = 0.05,
			grass = 0.2,
			sapling = 0.2,
			twiggytree = 0.2,
			grassgekko = 0.1,
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

			rock1=0.05,
			rock2=0.05,

			sapling=0.05,
			grass=1,						

			flower=1,

			green_mushroom = 0.4,

			berrybush=0.05,
			berrybush_juicy = 0.025,
			carrot_planted = 0.2,

			fireflies = 1.5,

			pond_mos=.01,

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

			grass = 1,
			sapling=0.03,
			berrybush=1,
			berrybush_juicy = 0.05,

			green_mushroom = 4,

			fireflies = 2,
			flower=5,

			molehill = 2,

			berrybush = 3,
			berrybush_juicy = 1.5,

			pond_mos = 0.15,
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
			grass = 1,
			sapling=0.05,

			deciduoustree = 10,

			blue_mushroom = 0.1,
			green_mushroom = 0.7,

			fireflies = 3,
			slurtlehole = 0.2,
			
			pighouse_yellow = 0.05,
		},
	}
})

AddRoom("SlimeySwamp", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MARSH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			marsh_bush = 0.2,
			marsh_tree = 0.05,
			mermhouse = 0.05,
			tentacle = 0.5,
			reeds = 0.15,
			pond_mos = 0.1,
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
		},
		distributepercent = 0.10,
		distributeprefabs = {
			marsh_bush = 0.2,
			marsh_tree = 0.05,
			rock1 = 0.2,
			rock2 = 0.1,
			rock3 = 0.1,
			reeds = 0.05,
			pond_mos = 0.1,
			grassgekko = 0.2,
			rock_ice = 0.05,
		}
	}
})

AddRoom("SlimeyMudRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			pillar_algae = .01,
			berrybush = 0.2,
			berrybush_juicy = 0.1,
			rock1 = 0.4,
			rock2 = 0.1,
			rock3 = 0.1,
			reeds = 0.05,
			pond_mos = 0.1,
			grassgekko = 0.2,
			spiderden = 0.01,
			flower = 2,
			slurtlehole = 0.2,
			green_mushroom = 0.2,
			rock_ice = 0.1,
			pighouse_yellow = 0.075,
		}
	}
})

AddRoom("SlimeyHerds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.10,
		distributeprefabs = {
			pillar_algae = .01,
			grassgekko = 0.2,
			beefalo = 0.1,
			perma_grass = 0.2,
			marsh_bush = 0.2,
			sapling = 0.1,
			twiggytree = 0.1,
			flint = 0.05,
			pond_mos = 0.05,
		}
	}
})

AddRoom("SlimeyStalagmite", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.UNDERROCK,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
        distributepercent = .15,
        distributeprefabs=
        {
            stalagmite = 0.2,
            pillar_stalactite = 0.1,
            spiderden = 0.05,
		fern = 0.5,
		slurtlehole = 0.1,
		grassgekko = 0.1,
		pighouse_yellow = 0.05,
        },
    }
})

AddRoom("SlimeyHounds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MARSH,
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
		tumbleweedspawner = 0.01,
		buzzardspawner = 0.05,
        },
    }
})

AddRoom("SlimeyMermCity", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SLIMEY,
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
        },
        distributepercent = .2,
        distributeprefabs=
        {
		marsh_tree = 3,
		slurper = 0.05,
		pond_mos = 0.1,
		reeds = 0.1,
        },
    }
})
