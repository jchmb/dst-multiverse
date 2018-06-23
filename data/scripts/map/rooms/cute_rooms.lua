AddPreferredLayout("BunnymanFarmers", "bunnyman_farmers")
AddPreferredLayout("GentleBunnyman", "gentle_bunnyman")
AddPreferredLayout("TrapRabbitMeat", "trap_rabbit_meat")
AddPreferredLayout("BunnymanFighters", "bunnyman_fighters")
AddPreferredLayout("BunnymanPirates", "bunnyman_pirates")
AddPreferredLayout("BunnymanTown", "bunnyman_town")
AddPreferredLayout("BunnylandSapfarm", "bunnyland_sapfarm")

AddStandardRoom(
	"CuteClearing",
	GROUND.FOREST,
	0.1,
	{
		hatpighouse=0.015,
        fireflies = 1,
        evergreen = 1.5,
        grass = .15,
        sapling=.9,
		twiggytree = 0.9,
		ground_twigs = 0.06,
        berrybush=.1,
        berrybush_juicy = 0.05,
        beehive=.05,
        red_mushroom = .01,
        green_mushroom = .02,
	},
	{
		spawnpoint_multiplayer = 1,
		-- homesign_welcome = 1,
	},
	{},
	nil,
	{"ExitPiece", "Chester_Eyebone", "StagehandGarden"}
)

AddStandardRoom(
	"BGCuteFungus",
	GROUND.FUNGUS,
	0.4,
	{
		carrot_planted = 0.02,
		evergreen = 0.02,
		mushtree_tall = 0.02,
		red_mushroom = 0.01,
		green_mushroom = 0.01,
		blue_mushroom = 0.01,
		grass = 0.1,
		sapling = 0.075,
		twiggytree = 0.075,
	}
)

AddRoom("CuteForest", {
					colour={r=.5,g=0.6,b=.080,a=.10},
					value = GROUND.FOREST,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .3,
					                distributeprefabs=
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
										trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}},
										colored_rabbithouse = 0.05,
					                },
					            }
					})

AddRoom("CutePlain", {
					colour={r=.8,g=.4,b=.4,a=.50},
					value = GROUND.SAVANNA,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .3,
					                distributeprefabs=
					                {
					                	rock_petrified_tree = 0.2,
					                    rock1 = 0.075,
					                    perma_grass = 0.5,
					                    rabbithole= 0.3,
					                    green_mushroom = .005,
					                    carrot_planted = 0.05,
					                },
					            }
					})

AddRoom("CuteBunnymanTown", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countstaticlayouts = {
			["BunnymanFarmers"] = 1,
		},
		distributepercent = 0.05,
		distributeprefabs = {
			fireflies = 0.05,
			carrot_planted = 0.05,
			colored_rabbithouse = 0.05,
			flower = 0.1,
			mushtree_medium = 0.6,
			mushtree_small = 0.6,
			red_mushroom = 0.05,
			green_mushroom = 0.03,
			blue_mushroom = 0.05,
		}
	}
})

AddRoom("CuteBunnymanTown2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUSGREEN,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countstaticlayouts = {
			-- ["GentleBunnyman"] = 1,
			["BunnymanTown"] = 1,
		},
		distributepercent = 0.03,
		distributeprefabs = {
			fireflies = 0.1,
			carrot_planted = 0.1,
			berrybush = 0.2,
			berrybush_juicy = 0.15,
			colored_rabbithouse = 0.1,
			flower = 0.1,
			mushtree_medium = 0.4,
			mushtree_small = 0.3,
			red_mushroom = 0.05,
			green_mushroom = 0.03,
			blue_mushroom = 0.03,
			rabbithole = 0.01,
		}
	}
})

AddRoom("CuteBunnymanTown3", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUSRED,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.1,
		distributeprefabs = {
			fireflies = 0.2,
			carrot_planted = 0.1,
			colored_rabbithouse = 0.1,
			sapling = 0.1,
			twiggytree = 0.2,
			mushtree_medium = 2,
			mushtree_small = 2,
			mushtree_tall = 1,
			red_mushroom = 0.1,
			green_mushroom = 0.1,
			blue_mushroom = 0.1,
			hatpighouse = 0.05,
			deciduoustree = 1,
			rock_ice = 0.5,
			rabbithole = 0.1,
		}
	}
})

AddRoom("CuteBunnymanTown4", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUSRED,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			carrot_planted = 0.05,
			grass = 0.05,
			evergreen = 0.05,
		}
	}
})

AddStandardRoom(
	"BGCuteSweetPotatoField",
	GROUND.GRASS,
	0.1,
	{
		deciduoustree = 1,
		evergreen = 1,
		sweet_potato_planted = 0.01,
		sapling = 0.05,
		grass = 0.05,
		twiggytree = 0.05,
	}
)

AddStandardRoom(
	"CuteSweetPotatoField",
	GROUND.GRASS,
	0.15,
	{
		deciduoustree = 3,
		sweet_potato_planted = 0.1,
		lightninggoat = 0.001,
		sapling = 0.05,
		grass = 0.05,
		twiggytree = 0.05,
	},
	{
		colored_rabbithouse = 1,
	}
)

AddStandardRoom(
	"BGCuteSapTreeForest",
	GROUND.QUAGMIRE_PARKFIELD,
	0.1,
	{
		spotspice_shrub = 0.01,
		sapling = 0.07,
		grass = 0.07,
		flower = 0.2,
		molehill = 0.01,
	}
)

AddStandardRoom(
	"CuteSapTreeForest",
	GROUND.QUAGMIRE_PARKFIELD,
	0.25,
	{
		saptree_small = 0.03,
		saptree_normal = 0.03,
		saptree_tall = 0.03,
		spotspice_shrub = 0.07,
		sapling = 0.05,
		grass = 0.05,
		flower = 0.15,
		rabbithole = 0.01,
	}
)

AddStandardRoom(
	"CuteSapTreeForestCore",
	GROUND.QUAGMIRE_PARKFIELD,
	0.3,
	{
		saptree_small = 0.05,
		saptree_normal = 0.03,
		saptree_tall = 0.03,
		flower = 0.1,
	},
	{
		catcoonden = 5,
		pond = 3,
	},
	{
		["BunnylandSapfarm"] = 1,
	}
)

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
		distributepercent = 0.3,
		distributeprefabs = {
			perma_grass = 0.2,
			bunneefalo = 0.01,
			rabbithole = 0.025,
			mushtree_medium = 0.025,
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
			rabbithole = 0.02,
			perma_grass = 0.05,
			koalefant_cute = 0.02,
			lightninggoat = 0.01,
			mushtree_small = 0.05,
			colored_rabbithouse=0.05,
		}
	}
})

AddRoom("CuteRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ROCKY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			hatrabbithouse = function() return math.random(0, 1) + 1 end,
		},
		prefabdata = {
			hatrabbithouse = {
				startinghat = "minerhat",
				colorfname = "colored",
			},
		},
		distributepercent = 0.15,
		distributeprefabs = {
			rock1 = 0.7,
			rock2 = 0.7,
			rock_iron = 0.1,
			rocks = 0.7,
			rock_ice = 0.5,
			flint = 0.7,
			molehill = 0.1,
			tallbirdnest=0.008,
			grassgekko = 0.8,
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
			rock_iron = 0.2,
			rocks = 1,
			flint = 0.7,
			grassgekko = 0.2,
			buzzardspawner = 0.1,
			catcoonden = 0.1,
			rock_ice = 0.7,
		}
	}
})

AddRoom("CuteFriends", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.FUNGUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.1,
		distributeprefabs = {
			carrot_planted = 0.1,
			grass = 0.15,
			colored_rabbithouse = 0.1,
			hatpighouse = 0.05,
			flower = 0.1,
			berrybush = .5,
			berrybush_juicy = 0.2,
			mushtree_tall = 0.5,
			mushtree_small = 0.5,
			sapling = 0.075,
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

			colored_rabbithouse=.15,
			catcoonden=.1,

			rock1=0.05,
			rock2=0.05,

			sapling=1,
			grass=0.05,

			flower=0.75,

			red_mushroom = 0.1,
			blue_mushroom = 0.1,
			green_mushroom = 0.1,

			berrybush=0.2,
			berrybush_juicy = 0.1,
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
			sapling= 0.2,
			berrybush= 0.5,
			berrybush_juicy = 0.05,

			carrot_planted = 0.2,
			red_mushroom = 1,
			blue_mushroom = 1,
			green_mushroom = 1,

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
		distributepercent = .4,
		distributeprefabs={
			grass = .03,
			sapling= 0.2,
			carrot_planted=0.2,

			mushtree_medium = 2,
			mushtree_small = 2,
			mushtree_tall = 2,
			catcoonden = .05,

			red_mushroom = 0.15,
			blue_mushroom = 0.15,
			green_mushroom = 0.15,

			fireflies = 3,

			colored_rabbithouse = 0.1,
		},
	}
})

AddStandardRoom(
	"CuteSpiderForest",
	GROUND.FOREST,
	0.6,
	{
		evergreen_sparse = 8,
		evergreen = 3,
		ground_twigs = 0.2,
		red_mushroom = 0.1,
		green_mushroom = 0.1,
		blue_mushroom = 0.1,
	},
	{
		spiderden = 1,
	},
	{
		["BunnymanFighters"] = 1,
	}
)

AddStandardRoom(
	"CuteBunnyDefense",
	GROUND.FUNGUSGREEN,
	0.1,
	{
		mushtree_tall = 6,
		fireflies = 1,
		carrot_planted = 0.2,
		rabbithole = 0.2,
		colored_rabbithouse = 0.1,
	}
)

AddCenterRoom(
	"CuteGiantBunnyLair",
	GROUND.GRASS,
	0.5,
	{
		grass = 0.6,
		colored_rabbithouse = 0.1,
		carrot_planted = 0.1,
		rabbithole = 0.5,
	},
	{
		fireflies = 6,
		giant_bunnyman_spawner = 1,
		marbletree = function()
			return math.random(4, 6) + 3
		end,
		critterlab = 1,
	}
)

AddStandardRoom(
	"CuteBunnymanTown5",
	GROUND.FUNGUS,
	0.4,
	{
		fireflies = 3,
		grass = 0.3,
		hatrabbithouse = 0.3,
		mushtree_tall = 7,
		mushtree_medium = 5,
		carrot_planted = 0.2,
		rabbithole = 0.1,
	},
	{},
	{},
	{
		hatrabbithouse = {
			startinghat = "flowerhat",
			colorfname = "colored",
		}
	}
)

AddRoadPoisonRoom(
	"BGCuteSwamp",
	GROUND.MARSH,
	0.2,
	{
		marsh_bush = 0.1,
		marsh_tree = 0.1,
		pond_mos = 0.03,
		carrot_planted = 0.1,
		reeds = 0.1,
	}
)

AddRoadPoisonRoom(
	"CuteSwamp",
	GROUND.MARSH,
	0.2,
	{
		marsh_bush = 0.1,
		marsh_tree = 0.1,
		pond_mos = 0.03,
		tentacle = 1,
		reeds = 0.1,
	}
)

AddRoadPoisonRoom(
	"CuteSwampMutants",
	GROUND.MARSH,
	0.2,
	{
		marsh_bush = 0.1,
		marsh_tree = 0.4,
		reeds = 0.2,
		mutant_rabbithouse = 0.1,
	}
)

AddStandardRoom(
	"BGCuteBeach",
	GROUND.SAND,
	0.2,
	{
		rocks = 0.01,
		sapling = 0.05,
		grass = 0.05,
		palmtree = 0.1,
		sandhill = 0.05,
	}
)

AddStandardRoom(
	"CuteBeachEntrance",
	GROUND.SAND,
	0.2,
	{
		mushtree_small = 0.05,
		sapling = 0.05,
		grass = 0.05,
		carrot_planted = 0.05,
		sandhill = 0.1,
	}
)

AddStandardRoom(
	"CuteBeach",
	GROUND.SAND,
	0.2,
	{
		rock_limpet = 0.2,
		mushtree_small = 0.05,
		sapling = 0.05,
		grass = 0.05,
		palmtree = 0.1,
		sandhill = 0.1,
	}
)

AddStandardRoom(
	"CuteBeachPirates",
	GROUND.SAND,
	0.25,
	{
		mushtree_small = 0.05,
		sapling = 0.05,
		grass = 0.05,
		palmtree = 0.1,
		sandhill = 0.1,
	},
	{
		hatrabbithouse = 0.1,
	},
	{},
	{
		hatrabbithouse = {
			startinghat = "piratehat",
			colorfname = "default",
		},
	}
	-- {},
	-- {
	-- 	["BunnymanPirates"] = 1,
	-- }
)

AddStandardRoom(
	"CuteDesert",
	GROUND.DIRT_NOISE,
	0.15,
	{
		marsh_bush = 0.05,
		marsh_tree = 0.2,
		rock_flintless = 1,
		--rock_ice = .5,
		grass = 0.1,
		grassgekko = 0.4,
		cactus = 0.2,
		tumbleweedspawner = .01,
	},
	{
		hatrabbithouse = 2,
	},
	{},
	{
		hatrabbithouse = {
			startinghat = "watermelonhat",
			colorfname = "desert",
		},
	}
)

AddStandardRoom(
	"CuteDesertHounds",
	GROUND.DIRT_NOISE,
	0.15,
	{
		marsh_bush = 0.05,
		marsh_tree = 0.2,
		rock_flintless = 1,
		houndbone = 0.05,
		--rock_ice = .5,
		grass = 0.1,
		grassgekko = 0.4,
		cactus = 0.2,
		tumbleweedspawner = .01,
	}
)

AddStandardRoom(
	"CuteBeeClearing",
	GROUND.GRASS,
	0.03,
	{
		carrot_planted=0.003,
	},
	{
		fireflies=1,
		flower=7,
		beehive=1,
		hatrabbithouse=1,
	},
	{},
	{
		hatrabbithouse={
			startinghat="beehat",
			colorfname="colored",
		}
	}
)
