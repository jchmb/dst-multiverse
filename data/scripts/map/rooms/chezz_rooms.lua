AddRequiredStaticLayout("PigKingCyborg", "default_pigking_cyborg")

AddRoom("ChezzFungusNoiseForest", {
    colour={r=1.0,g=1.0,b=1.0,a=0.9},
    value = GROUND.BRICK,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        distributepercent = .4,
        distributeprefabs=
        {
            mushtree_medium = 2.0,
            mushtree_tall = 3.0,
            mushtree_small = 3.0,
            red_mushroom = 0.5,
            green_mushroom = 0.5,
            blue_mushroom = 0.5,

            grass = 0.1,
    	    sapling = 0.1,
    	    twiggytree = 0.1,
    	    flint = 0.2,
        },
    }
})

AddRoom("ChezzWetWilds", {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = GROUND.BRICK,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        distributepercent = 0.25,
        distributeprefabs=
        {
            lichen = .25,
            cave_fern = 0.1,
            pond_mos = 0.1,
            slurper = .05,
        }
    }
})

--Lichen Meadow
AddRoom("ChezzLichenMeadow", {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = GROUND.BRICK,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        distributepercent = 0.15,
        distributeprefabs=
        {
            lichen = 1.0,
            cave_fern = 1.0,
            pillar_algae = 0.1,
            slurper = 0.35,
            fissure_lower = 0.05,

            flower_cave = .05,
            flower_cave_double = .03,
            flower_cave_triple = .01,

            worm = 0.07,
            wormlight_plant = 0.15,
        }
    }
})

--Lichen Land
AddRoom("ChezzLichenLand", {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = GROUND.ROCKY,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        distributepercent = 0.35,
        distributeprefabs=
        {
            lichen = 2.0,
            cave_fern = 0.5,
            slurper = 0.05,
        }
    }
})

AddRoom("BGChezz", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.CHECKER,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			rock1 = 0.1,
			flower_evil = 0.05,
			flower_cave = 0.1,
			knight = 0.01,
		}
	}
})

AddRoom("ChezzLand", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.CHECKER,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			flower_evil = 1,
			chessjunk1 = .1,
			chessjunk2 = .1,
			chessjunk3 = .1,
			ruins_rubble_table = 0.01,
            		ruins_rubble_chair = 0.01,
            		ruins_rubble_vase = 0.01,
			rook = 0.01,
			bishop = 0.01,
		}
	}
})

AddRoom("ChezzLand2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.CHECKER,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countstaticlayouts={
			["PigGuards"] = 1,
		},
		distributepercent = 0.3,
		distributeprefabs = {
			flower_evil = 3,
			chessjunk1 = 0.1,
			bishop = 0.01,
		}
	}
})

AddRoom("ChezzRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.BRICK,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			meteorspawner = 2,
		},
		distributepercent = 0.3,
		distributeprefabs = {
			rock1 = 0.15,
			rock2 = 0.1,
			flint = 0.2,
			rocks = 0.1,
            rock_iron = 0.1,
			rock_ice = 0.1,
		}
	}
})

AddRoom("BGChezzDeciduous", {
    colour={r=.1,g=.8,b=.1,a=.50},
    value = GROUND.BRICK,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        distributepercent = .2,
        distributeprefabs={
            deciduoustree = 3,
            pighouse_cyborg = 0.15,

            rock1=0.05,
            rock2=0.05,

            sapling=1,
            grass=0.05,

            berrybush=0.05,
            berrybush_juicy = 0.025,
            carrot_planted = 0.2,

            fireflies = 1.5,

            pond=.01,
        },
    }
})

AddRoom("ChezzMagicalDeciduous", {
    colour={r=0,g=.9,b=0,a=.50},
    value = GROUND.BRICK,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        countstaticlayouts={
            ["DeciduousPond"] = 1,
        },
        countprefabs = {
            chessjunk1 = 3,
        },
        distributepercent = .3,
        distributeprefabs={
            deciduoustree = 2,
            berrybush=1,
            berrybush_juicy = 0.05,

            red_mushroom = 2,
            blue_mushroom = 2,
            green_mushroom = 2,

            fireflies = 4,

            berrybush = 3,
            berrybush_juicy = 1.5,
        },
    }
})

AddRoom("ChezzDeepDeciduous", {
    colour={r=0,g=.9,b=0,a=.50},
    value = GROUND.BRICK,
    tags = {"ExitPiece", "Chester_Eyebone"},
    contents =  {
        countprefabs = {
            chessjunk2 = 2,
        },
        distributepercent = .3,
        distributeprefabs={
            deciduoustree = 10,
            grass = .1,
            rock = .1,
            fireflies = 1,
        },
    }
})

AddRoom("ChezzPigKingdom", {
    colour={r=0.8,g=.8,b=.1,a=.50},
    value = GROUND.BRICK,
    tags = {"Town"},
    required_prefabs = {"pigking_cyborg"},
    contents =  {
        countstaticlayouts={
            ["PigKingCyborg"]=1,
            ["CropCircle"]=function() return math.random(0,1) end,
            ["TreeFarm"]=   function()
                                if math.random() > 0.97 then
                                    return math.random(1,2)
                                end
                                return 0
                            end,
        },
        countprefabs= {
            pighouse_cyborg = function () return 5 + math.random(4) end,
            ancient_altar_broken = 1,
        },
        distributepercent = 0.3,
        distributeprefabs = {
            coffeebush = 0.02,
            mintybush = 0.02,
            bittersweetbush = 0.02,
        },
    }
})
