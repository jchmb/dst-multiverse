AddRoom("BGFire", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			sapling = 0.15,
			twiggytree = 0.15,
			grass = 0.05,
			evergreen = 5,
			red_mushroom = 0.01,
			flint = 0.1,
		}
	}
})

--[[
  Tier 0
--]]

AddRoom("FireRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.MAGMA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			flint = 0.1,
			rock_charcoal = 0.1,
			rock2 = 0.03,
			rocks = 0.01,
		}
	}
})

--[[
  Tier 1
--]]

AddRoom("FireForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.7,
		distributeprefabs = {
			evergreen_sparse = 8,
			spiderden = 0.05,
			ground_twigs = 0.1,
			sapling = 0.1,
			red_mushroom = 0.25,
		}
	}
})

AddRoom("FireForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.7,
		distributeprefabs = {
			evergreen_sparse = 8,
			spiderden = 0.05,
			ground_twigs = 0.1,
			sapling = 0.1,
			red_mushroom = 0.25,
		}
	}
})
