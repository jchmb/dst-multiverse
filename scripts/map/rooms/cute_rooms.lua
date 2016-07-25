AddRoom("CuteBunnymanTown", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.07,
		distributeprefabs = {
			fireflies = 0.2,
			carrot_planted = 1,
			rabbithouse = 0.1,
			flower = 0.1,
			mushtree_medium = 2,
			mushtree_small = 3,
			red_mushroom = 0.1,
			green_mushroom = 0.1,
			blue_mushroom = 0.1
		}
	}
})

AddRoom("CuteBunnymanTown2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUSGREEN,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.07,
		countprefabs = {
			migration_portal = 1,
		},
		distributeprefabs = {
			fireflies = 0.2,
			carrot_planted = 0.5,
			berrybush = 0.5,
			berrybush_juicy = 0.25,
			rabbithouse = 0.1,
			flower = 0.1,
			mushtree_medium = 2,
			mushtree_small = 3,
			red_mushroom = 0.1,
			green_mushroom = 0.1,
			blue_mushroom = 0.1,
			catcoonden = 0.1,
			rock2 = 0.05,
		}
	}
})

AddRoom("CuteBunnymanTown3", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUSRED,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.07,
		distributeprefabs = {
			fireflies = 0.2,
			carrot_planted = 1,
			rabbithouse = 0.1,
			sapling = 0.2,
			twiggytree = 0.2,
			mushtree_medium = 2,
			mushtree_small = 2,
			mushtree_tall = 1,
			red_mushroom = 0.1,
			green_mushroom = 0.1,
			blue_mushroom = 0.1,
			pighouse = 0.05,
			deciduoustree = 1,
			rock_ice = 0.5,
		}
	}
})

AddRoom("CuteMonkeyRoom", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.DIRT,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.07,
		distributeprefabs = {
			cave_banana_tree = 0.08,
			monkeybarrel = 0.03,
			tree = {weight = 2, prefabs = {"evergreen", "deciduoustree"}}
		}
	}
})

AddRoom("CuteHerds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			perma_grass = 0.1,
			beefalo = 0.1,
			rabbithole = 0.2,
			mushtree_medium = 0.5
		}
	}
})

AddRoom("CuteHerds2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			rabbithole = 0.2,
			perma_grass = 0.1,
			koalefant_summer = 0.05,
			lightninggoat = 0.01,
			mushtree_small = 0.7
		}
	}
})

AddRoom("CuteRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			rock1 = 0.7,
			rock2 = 0.7,
			rocks = 0.7,
			rock_ice = 0.5,
			flint = 0.7,
			molehill = 0.1,
			tallbirdnest=0.008,
			grassgekko = 0.7,
			catcoonden = 0.1
		}
	}
})

AddRoom("CuteRocks2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs={
			meteorspawner = function() return math.random(1,2) end,
		},
		distributepercent = 0.15,
		distributeprefabs = {
			rock1 = 1,
			rock2 = 1,
			rocks = 1,
			flint = 0.7,
			molehill = 0.1,
			tallbirdnest=0.1,
			grassgekko = 0.2,
			buzzardspawner = 0.1,
			catcoonden = 0.1,
			rock_ice = 0.7
		}
	}
})

AddRoom("CuteFriends", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.2,
		distributeprefabs = {
			carrot_planted = 1,
			grass = 0.2,
			rabbithouse = 0.2,
			pighouse = 0.2,
			flower = 0.5,
			catcoonden = 0.1,
			berrybush = .5,
			berrybush_juicy = 0.25,
			mushtree_tall = 2,
			mushtree_small = 1,
			sapling = 0.1,
			twiggytree = 0.1,
		}
	}
})

AddRoom("BGCuteDeciduous", {
	colour={r=.1,g=.8,b=.1,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .2,
		distributeprefabs={
			mushtree_tall=3,
			mushtree_medium=1,

			rabbithouse=.15,
			catcoonden=.1,

			rock1=0.05,
			rock2=0.05,

			sapling=1,
			grass=0.05,						

			flower=0.75,

			red_mushroom = 0.1,
			blue_mushroom = 0.1,
			green_mushroom = 0.1,

			berrybush=0.05,
			berrybush_juicy = 0.025,
			carrot_planted = 0.2,

			fireflies = 1.5,

			pond=.01,
		},
	}
})

AddRoom("CuteMagicalDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countstaticlayouts={
			["DeciduousPond"] = 1,
		},
		distributepercent = .3,
		distributeprefabs={
			grass = .03,
			sapling=1,
			berrybush=1,
			berrybush_juicy = 0.05,

			red_mushroom = 2,
			blue_mushroom = 2,
			green_mushroom = 2,

			fireflies = 2,
			flower=5,

			molehill = 2,
			catcoonden = .25,

			berrybush = 3,
			berrybush_juicy = 1.5,
		},
	}
})

AddRoom("CuteDeepDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = .4,
		distributeprefabs={
			grass = .03,
			sapling=1,
			carrot_planted=0.5,

			deciduoustree = 10,
			catcoonden = .05,

			red_mushroom = 0.15,
			blue_mushroom = 0.15,
			green_mushroom = 0.15,

			fireflies = 3,
		},
	}
})
