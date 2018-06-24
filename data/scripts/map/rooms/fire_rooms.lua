AddRequiredStaticLayout("DragonflyFireArena", "dragonfly_fire_arena")
AddRequiredStaticLayout("PigKingFire", "default_pigking_fire")

AddRoom("BGFire", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.08,
		distributeprefabs = {
			sapling = 0.1,
			twiggytree = 0.1,
			grass = 0.05,
			volcano_shrub = 0.03,
			flint = 0.1,
			elephantcactus = 0.01,
		}
	}
})

AddStandardRoom(
	"FireClearing",
	GROUND.ASH,
	0.1,
	{
		sapling = 0.1,
		twiggytree = 0.1,
		perma_grass = 0.1,
		flint = 0.05,
		evergreen = 0.1,
	},
	{
		spawnpoint_multiplayer = 1,
	},
	{},
	{
		evergreen = {burnt = true},
	}
)

AddStandardRoom(
	"BGFireBeach",
	GROUND.SAND,
	0.2,
	{
		sapling = 0.1,
		grass = 0.1,
		palmtree = 0.5,
		flint = 0.1,
		crate = 0.05,
		seashell_beached = 0.1,
		sandhill = 0.1,
	}
)

AddStandardEdgeRoom(
	"FireBeach",
	GROUND.SAND,
	0.2,
	{
		sapling = 0.1,
		ground_twigs = 0.05,
		perma_grass = 0.125,
		palmtree = 1.5,
		flint = 0.1,
		rock = 0.05,
		rock_limpet = 0.05,
		seashell_beached = 0.1,
		sandhill = 0.1,
	}
)

AddStandardEdgeRoom(
	"FireBeach2",
	GROUND.SAND,
	0.175,
	{
		sapling = 0.1,
		grass = 0.125,
		palmtree = 1,
		flint = 0.1,
		seashell_beached = 0.1,
		sandhill = 0.1,
		sharkittenspawner = 0.02,
		grassgekko = 0.1,
	}
)

AddStandardEdgeRoom(
	"FireBeach3",
	GROUND.SAND,
	0.15,
	{
		wildborehouse = 0.03,
		crate = 0.03,
		rock_limpet = 0.16,
		palmtree = 0.09,
		sandhill = 0.2,
	}
)

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
			rocks = 0.03,
		}
	}
})

AddStandardRoom(
	"BGFireJungle",
	GROUND.JUNGLE,
	0.5,
	{
		jungletree = 0.2,
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		blue_mushroom = 0.01,
		green_mushroom = 0.01,
		cave_banana_tree = 0.04,
		bambootree = 0.15,
	}
)

AddStandardRoom(
	"FireJungle",
	GROUND.JUNGLE,
	0.3,
	{
		jungletree = 0.3,
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		snake_hole = 0.05,
		brown_mushroom = 0.1,
		cave_banana_tree = 0.07,
		flint = 0.05,
		bambootree = 0.2,
		wildbore_house = 0.05,
	},
	{
		lureplant = 1,
	}
)

AddStandardRoom(
	"FireMonkeyJungle",
	GROUND.JUNGLE,
	0.2,
	{
		jungletree = 0.3,
		cave_banana_tree = 0.07,
		fireflies = 0.8,
		ground_twigs = 0.1,
		grass = 0.2,
		bambootree = 0.1,
	},
	{
		monkeybarrel = GetRandomFn(1, 2),
	}
)

AddStandardRoom(
	"FireSpiderJungle",
	GROUND.JUNGLE,
	0.2,
	{
		jungletree = 0.2,
		cave_banana_tree = 0.03,
		bambootree = 0.1,
	},
	{
		spiderden_poisonous = GetRandomFn(2, 2),
		flower_evil = GetRandomFn(1, 2),
	}
)

AddStandardRoom(
	"BGFireDesert",
	GROUND.DIRT_NOISE,
	0.07,
	{
		marsh_bush = 0.05,
		marsh_tree = 0.2,
		rock_flintless = 1,
		--rock_ice = .5,
		grass = 0.1,
		grassgekko = 0.4,
		houndbone = 0.2,
		cactus = 0.2,
		tumbleweedspawner = .01,
	}
)

AddStandardCentroidRoom(
	"FireDesert",
	GROUND.DIRT_NOISE,
	0.08,
	{
		rock_flintless = .8,
		--rock_ice = .5,
		marsh_bush = 0.25,
		marsh_tree = 0.75,
		grass = .5,
		grassgekko = 0.6,
		cactus = .7,
		houndbone = .6,
		tumbleweedspawner = .05,
		basalt = 0.02,
	}
)

AddStandardCentroidRoom(
	"FireDesertHounds",
	GROUND.DIRT_NOISE,
	0.08,
	{
		rock_flintless = .8,
		--rock_ice = .5,
		grass = .5,
		cactus = .7,
		houndbone = .8,
	},
	{
		houndmound_fire = 3,
	}
)

AddStandardCentroidRoom(
	"BGFireDragoonLair",
	GROUND.MAGMA,
	0.1,
	{
		rock_magma = 0.01,
		rocks = 0.001,
		volcano_shrub = 1,
	},
	{},
	{}
)

AddStandardCentroidRoom(
	"FireDragoonLair",
	GROUND.MAGMA,
	0.1,
	{
		dragoonden = 0.05,
		rock_magma = 0.05,
		rock_magma_gold = 0.01,
		rock_obsidian = 0.01,
		evergreen = 0.1,
		volcano_shrub = 0.1,
	},
	{},
	{},
	{
		evergreen = {burnt = true},
	}
)

--[[
  Tier 1
--]]

AddRoom("FireForest2", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.3,
		distributeprefabs = {
			ground_twigs = 0.1,
			sapling = 0.1,
			volcano_shrub = 0.1,
			elephantcactus = 0.04,
			grass = 0.05,
			molehill = 0.05,
		}
	}
})

AddRoom("FireForest3", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ASH,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.5,
		distributeprefabs = {
			spiderden = 0.01,
			ground_twigs = 0.1,
			sapling = 0.1,
			twiggytree = 0.1,
			red_mushroom = 0.03,
			volcano_shrub = 0.2,
			molehill = 0.05,
			rock2 = 0.01,
			rocks = 0.01,
		}
	}
})

AddStandardRoom(
	"BGFireCoffee",
	GROUND.MAGMA,
	0.1,
	{
		volcano_shrub = 0.07,
		sapling = 0.05,
		grass = 0.05,
		twiggytree = 0.05,
		flint = 0.05,
		ground_twigs = 0.05,
	}
)

AddStandardCentroidRoom(
	"FireCoffee",
	GROUND.MAGMA,
	0.17,
	{
		volcano_shrub = 0.07,
		coffeebush = 0.1,
		sapling = 0.05,
		grass = 0.05,
		twiggytree = 0.05,
	},
	{
		tallbirdnest = 1,
	}
)

--[[
	Tier 4
]]
AddStandardCentroidRoom(
	"BGFireDragonflyTerritory",
	GROUND.VOLCANO,
	0.1,
	{
		flint = 0.01,
		evergreen = 0.3,
		charcoal = 0.01,
		rock_charcoal = 0.01,
		volcano_shrub = 0.3,
	},
	{},
	{},
	{
		evergreen = {burnt = true},
	}
)

AddStandardCentroidRoom(
	"FireDragonflyTerritory",
	GROUND.VOLCANO,
	0.2,
	{
		rock_magma = 0.02,
		rock_magma_gold = 0.01,
		lava_pond = 0.01,
		evergreen = 0.1,
		volcano_shrub = 0.2,
	},
	{},
	{},
	{
		evergreen = {burnt = true},
	}
)

AddStandardCentroidRoom(
	"FireDragonflyLair",
	GROUND.VOLCANO,
	0.15,
	{
		rock_magma_gold = 0.01,
		lava_pond = 0.01,
		volcano_shrub = 1,
	},
	{
		rock_charcoal = 5,
		obsidian_workbench = 1,
	},
	{
		["DragonflyFireArena"] = 1,
	},
	{
		evergreen = {burnt = true},
	}
)

--[[
	Pigking
--]]

AddRoom("BGFireDeciduous", {
	colour={r=.1,g=.8,b=.1,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .15,
		distributeprefabs={
			volcano_shrub = 0.3,

			catcoonden=0.1,

			rock1=0.1,
			rock2=0.05,

			sapling=0.1,
			grass=0.1,

			flower=0.75,

			red_mushroom = 0.1,
			blue_mushroom = 0.1,
			green_mushroom = 0.1,

			berrybush = 0.05,

			fireflies = 0.5,

			pighouse_fire = 0.02,
		},
	}
})

AddRoom("FireMagicalDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .3,
		distributeprefabs={
			grass =0.1,
			sapling=0.1,

			red_mushroom = 2,
			blue_mushroom = 2,
			green_mushroom = 2,

			molehill = 1,
			catcoonden = .25,

			berrybush = 0.1,

			fireflies = 2,
			rock_charcoal = 0.1,
		},
	},
	internal_type = 0
})

AddRoom("FireDeepDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .3,
		distributeprefabs={
			grass =0.1,
			sapling=0.1,
			volcano_shrub = 0.05,
			catcoonden = .05,

			fireflies = 2,

			berrybush = 0.1,

			rock_charcoal = 0.1,
			pighouse_fire = 0.05,
		},
	},
	internal_type = 0
})

AddRoom("FirePigKingdom", {
	colour={r=0.8,g=.8,b=.1,a=.50},
	value = GROUND.MAGMA,
	tags = {"Town"},
	required_prefabs = {"pigking_fire"},
	contents =  {
		countstaticlayouts={
			["PigKingFire"]=1,
			["CropCircle"]=function() return math.random(0,1) end,
		},
		countprefabs= {
			pighouse_fire = function () return 2 + math.random(2) end,
			volcano_shrub = GetRandomFn(6, 4),
			lava_pond = 2,
		}
	},
	internal_type = 0
})
