AddRequiredStaticLayout("DragonflyFireArena", "dragonfly_fire_arena")

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

AddStandardRoom(
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

AddStandardRoom(
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
		sharkittenspawner = 0.01,
		grassgekko = 0.1,
	}
)

AddStandardRoom(
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
			rocks = 0.01,
		}
	}
})

AddStandardRoom(
	"BGFireDragoonLair",
	GROUND.MAGMA,
	0.1,
	{
		rock_magma = 0.01,
		rocks = 0.001,
		evergreen = 1,
	},
	{},
	{},
	{
		evergreen = {burnt = true},
	}
)

AddStandardRoom(
	"FireDragoonLair",
	GROUND.MAGMA,
	0.1,
	{
		dragoonden = 0.01,
		rock_magma = 0.05,
		rock_magma_gold = 0.01,
		rock_obsidian = 0.01,
		evergreen = 0.5,
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
	value = GROUND.LAVA_ROCK,
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

AddRoom("FireForest3", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.VOLCANO,
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

--[[
	Tier 4
]]
AddStandardRoom(
	"BGFireDragonflyTerritory",
	GROUND.VOLCANO,
	0.1,
	{
		flint = 0.01,
		evergreen = 1,
		charcoal = 0.01,
	},
	{},
	{},
	{
		evergreen = {burnt = true},
	}
)

AddStandardRoom(
	"FireDragonflyTerritory",
	GROUND.VOLCANO,
	0.2,
	{
		rock_magma = 0.02,
		rock_magma_gold = 0.01,
		lava_pond = 0.01,
		evergreen = 0.5,
	},
	{},
	{},
	{
		evergreen = {burnt = true},
	}
)

AddStandardRoom(
	"FireDragonflyLair",
	GROUND.VOLCANO,
	0.15,
	{
		rock_magma_gold = 0.01,
		lava_pond = 0.01,
		evergreen = 0.5,
	},
	{
		rock_charcoal = 0.01,
	},
	{
		["DragonflyFireArena"] = 1,
	},
	{
		evergreen = {burnt = true},
	}
)
