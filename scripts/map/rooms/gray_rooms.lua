local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
Layouts["ChestShadowTrap"] = GLOBAL.require("map/layouts/chest_shadow_trap")
Layouts["PigKingGray"] = StaticLayout.Get(
	"map/static_layouts/default_pigking_gray",
	{
		start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		layout_position = GLOBAL.LAYOUT_POSITION.CENTER
	}
)

AddRoom("BGGray", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.GRASS_GRAY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			sapling = 0.2,
			twiggytree = 0.2,
			evergreen = 5,
			blue_mushroom = 0.05,
			green_mushroom = 0.05,
			red_mushroom = 0.01,
			flower_evil = 0.05,
			flower_cave = 0.1,
			cave_fern = 1,
			pond_mos = 0.01,
			spiderden = 0.1,
			flint = 0.1,
			slurper = 0.03,
			tallbirdnest = 0.01,
			beardlordhouse = 0.09,
		}
	}
})

AddRoom("GrayForest", {
					colour={r=.5,g=0.6,b=.080,a=.10},
					value = GROUND.ASH,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
									countprefabs = {
    										spawnpoint_multiplayer = 1,
    									},
					                distributepercent = .3,
					                distributeprefabs=
					                {
                                        fireflies = 0.2,
										--evergreen = 6,
										rock_petrified_tree = 0.015,
					                    rock1 = 0.05,
					                    grass = .05,
					                    sapling=.8,
					                    flint = 0.07,
										twiggytree = 0.8,
										ground_twigs = 0.06,					                    
										--rabbithole=.05,
					                    coffeebush = 0.1,
					                    red_mushroom = .03,
					                    green_mushroom = .02,
										trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}}
					                },
					            }
					})

AddRoom("GrayPetGraveyard", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FOREST,
	tags = {"ExitPiece", "Chester_Eyebone", "Mist"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.2,
		countprefabs = {
			gravestone = function() return 3 + math.random(4) end,
			mound = function() return 5 + math.random(2) end
		},
		distributeprefabs = {
			catcoonden = 0.1,
			sapling = 0.1,
			tagswiggytree = 0.1,
			evergreen = 1,
			ghost = 0.08,
		}
	}
})

AddRoom("GraySpiderTown", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FOREST,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.2,
		countprefabs = {
			skeleton = function() return 6 + math.random(3) end
		},
		distributeprefabs = {
			spiderden = 0.15,
			sapling = 0.1,
			twiggytree = 0.1,
			flower_evil = 0.1
		}
	}
})

AddRoom("GrayCaveSpiders", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.UNDERROCK,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
        distributepercent = .25,
        distributeprefabs=
        {
            stalagmite = 0.5,
            pillar_cave = 0.1,
            pillar_stalactite = 0.1,
            spiderhole = 0.1,
            batcave = 0.1,

            thulecite = 0.01,
            thulecite_pieces = 0.05,
        },
    }
})

AddRoom("GrayEvilMoles", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.GRASS_GRAY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 2,
		},
		distributepercent = 0.2,
		distributeprefabs = {
			molehill = 0.3,
			flower_evil = 0.4,
			flint = 1,
			rock1 = 0.1
		}
	}
})

AddRoom("GrayHoundTown", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece"},
	contents =  {
		distributepercent = 0.2,
		countprefabs = {
			houndmound = function() return 2 + math.random(2) end,
			redgem = function() return 1 + math.random(2) end,
			bluegem = function() return 1 + math.random(2) end
		},
		distributeprefabs = {
			houndmound = 0.05,
			rock1 = 0.3,
			rock2 = 0.4,
			rock3 = 0.2,
			flint = 0.5,
			tumbleweedspawner = 0.01
		}
	}
})

AddRoom("GrayHoundTownVarg", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece"},
	contents =  {
		distributepercent = 0.2,
		countprefabs = {
			houndmound = 2,
			purplegem = function() return 1 + math.random(2) end,
			yellowgem = function() return 1 + math.random(2) end,
			warg = 1,
		},
		distributeprefabs = {
			houndmound = 0.05,
			rock1 = 0.3,
			rock2 = 0.4,
			rock3 = 0.2,
			flint = 0.5,
			thulecite_pieces = 0.05,
		}
	}
})

AddRoom("GraySwamp", {
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
			tentacle = 0.1,
			reeds = 0.15
		}
	}
})

AddRoom("GrayRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 2,
		},
		distributepercent = 0.2,
		distributeprefabs = {
			meteorspawner = 1,
			rock1 = 0.5,
			rock2 = 0.3,
			rock_flintless_med = 0.5,
			rocky = 0.3,
			grassgekko = 0.2,
			rock_ice = 0.4,
		}
	}
})

AddRoom("GrayMermRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			mermhouse = 3,
		},
		distributepercent = 0.2,
		distributeprefabs = {
			rock1 = 0.1,
			rock_flintless_med = 0.6,
			rock_moon = 0.05,
			coffeebush = 0.1,
		}
	}
})


AddRoom("BGGrayDeciduous", {
	colour={r=.1,g=.8,b=.1,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .2,
		distributeprefabs={
			deciduoustree = 1,

			catcoonden=0.1,

			rock1=0.1,
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

			flower_cave = 0.2,
			flower_cave_double = 0.1,
			flower_cave_triple = 0.05,

			pond_mos=.01,

			gravestone = 0.01
		},
	}
})

AddRoom("GrayMagicalDeciduous", {
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

			red_mushroom = 2,
			blue_mushroom = 2,
			green_mushroom = 2,

			flower_cave = 0.3,
			flower_cave_double = 0.2,
			flower_cave_triple = 0.1,
			flower=5,

			molehill = 2,
			catcoonden = .25,
		},
	}
})

AddRoom("GrayDeepDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .4,
		distributeprefabs={
			grass = .03,
			sapling=1,

			deciduoustree = 10,
			catcoonden = .05,

			red_mushroom = 0.15,
			blue_mushroom = 0.4,
			green_mushroom = 0.15,

			flower_cave = 0.2,
			flower_cave_double = 0.1,
			flower_cave_triple = 0.1,
		},
	}
})

AddRoom("GrayPigKingdom", {
	colour={r=0.8,g=.8,b=.1,a=.50},
	value = GROUND.GRASS,
	tags = {"Town"},
	required_prefabs = {"pigking_gray"},
	contents =  {
		countstaticlayouts={
			["PigKingGray"]=1,
			["CropCircle"]=function() return math.random(0,1) end,
			["TreeFarm"]= 	function()
								if math.random() > 0.97 then 
									return math.random(1,2) 
								end 
								return 0 
							end,
		},
		countprefabs= {
			pighouse_gray = function () return 5 + math.random(4) end,
		}
	}
})

AddRoom("GrayHerds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			perma_grass = 0.1,
			flower_cave = 0.2,
			rock2 = 0.1,
			grassgekko = 0.1
		}
	}
})

AddRoom("BGGray2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			rocks = 0.07,
			flint = 0.02,
			coffeebush = 0.1,
			spiderden = 0.01,
			basalt = 0.1,
		}
	}
})


AddRoom("GrayMoonRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			walrus_camp = 1,
		},
		distributepercent = 0.15,
		distributeprefabs = {
			rock_moon = 0.07,
			rocks = 0.07,
			pighouse_gray = 0.05,
			grassgekko = 0.1,
			basalt = 0.1,
			tumbleweedspawner = 0.01,
		}
	}
})

AddRoom("GrayGoats", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countstaticlayouts = {
			["ChestShadowTrap"] = 1,
		},
		countprefabs = {
			lightninggoat = 3,
		},
		distributepercent = 0.23,
		distributeprefabs = {
			basalt = 0.05,
			evergreen_sparse = 4,
			evergreen = 3,
			sapling = 0.1,
			twiggytree = 0.1,
			spiderden = 0.07,
			coffeebush = 0.1,
		}
	}
})

AddRoomWrapped(
	"GrayBeardlords",
	GROUND.ASH,
	{
		distributepercent = 0.3,
		distributeprefabs = {
			beardlordhouse = 0.15,
			coffeebush = 0.1,
			evergreen_sparse = 5,
			carrot_planted = 0.15,
			sapling = 0.1,
			twiggytree = 0.1,
		},
	}
)

AddStandardRoom(
	"GrayTallbirds",
	GROUND.ASH,
	0.12,
	{
		rock_moon = 0.05,
		rock1 = 0.1,
		rock2 = 0.05,
		rocks = 0.03,
		flint = 0.03,
	},
	{
		tallbirdnest = 3,
		thulecite_pieces = 2,
	}
)

AddRoom("GrayHerdsBeefalo", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			perma_grass = 0.2,
			flower_cave = 0.2,
			beefalo = 0.1,
			grassgekko = 0.1,
		}
	}
})