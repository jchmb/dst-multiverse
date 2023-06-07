local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
Layouts["BeaverKing"] = StaticLayout.Get(
	"map/static_layouts/default_beaver_king",
	{
		start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		layout_position = GLOBAL.LAYOUT_POSITION.CENTER
	}
)
Layouts["RewardMooseTreasure"] = GLOBAL.require("map/layouts/reward_moosetreasure")

AddStandardRoom(
	"BGWater",
	WORLD_TILES.GRASS_BLUE,
	0.5,
	{
		cave_banana_tree = 0.05,
		evergreen = 5,
		deciduoustree = 3,
		brown_mushroom = 0.1,
		fireflies = 1,
		sapling = 0.1,
		twiggytree = 0.1,
		grass = 0.1,
		bambootree = 0.02,
	}
)

--[[
	Tier 0
--]]

AddStandardRoom(
	"WaterClearing",
	WORLD_TILES.GRASS_BLUE,
	0.3,
	{
		evergreen = 2,
		deciduoustree = 1,
		cave_banana_tree = 0.007,
		fireflies = 0.7,
		grass = 0.1,
	},
	{
		spawnpoint_multiplayer = 1,
	}
)

AddStandardRoom(
	"WaterForest",
	WORLD_TILES.FOREST,
	0.7,
	{
		evergreen = 6,
		deciduoustree = 4,
		cave_banana_tree = 0.007,
		fireflies = 0.6,
		ground_twigs = 0.1,
		brown_mushroom = 0.1,
		grass = 0.2,
		wildbeaver_house = 0.1,
		rabbithole = 0.2,
	},
	{
		lureplant = 1,
	}
)

AddStandardRoom(
	"WaterRocks",
	WORLD_TILES.ROCKY,
	0.2,
	{
		rock1 = 0.05,
		rock2 = 0.1,
		pond = 0.03,
		flint = 0.03,
		rock_ice = 0.02,
	},
	{
		meteorspawner = 1,
	}
)

--[[
	Tier 1
--]]

AddStandardRoom(
	"WaterMeadow",
	WORLD_TILES.GRASS_BLUE,
	0.2,
	{
		pond_purple = 0.05,
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		beehive = 0.03,
		flower = 2,
		deciduoustree = 0.5,
	}
)

--[[
	Beaver King
--]]
AddRoom("WaterBeaverKingdom", {
	colour={r=0.8,g=.8,b=.1,a=.50},
	value = WORLD_TILES.GRASS_BLUE,
	tags = {"Town"},
	required_prefabs = {"beaver_king"},
	contents =  {
		distributepercent = 0.6,
		distributeprefabs = {
			deciduoustree = 4,
			evergreen = 4,
			evergreen_sparse = 2,
		},
		countstaticlayouts={
			["BeaverKing"]=1,
			["CropCircle"]=function() return math.random(0,1) end,
			["TreeFarm"]= 	function()
								if math.random() > 0.97 then
									return math.random(1,2)
								end
								return 0
							end,
		},
		countprefabs= {
			wildbeaver_house = GetRandomFn(5, 4),
			critterlab = 1,
		}
	}
})

--[[
	Tier 2
--]]

AddStandardRoom(
	"WaterMeadowMerms",
	WORLD_TILES.GRASS_BLUE,
	0.3,
	{
		pond_purple = 0.05,
		flower = 1,
		deciduoustree = 0.5,
		mermhouse_blue = 0.01,
		grass = 0.1,
		cave_banana_tree = 0.01,
		evergreen = 1,
	}
)

AddStandardRoom(
	"WaterOxHerds",
	WORLD_TILES.SAVANNA,
	0.15,
	{
		perma_grass = 0.1,
		pond = 0.05,
	},
	{
		ox = GetRandomFn(4, 4),
	}
)

AddStandardRoom(
	"WaterBeaverForest",
	WORLD_TILES.GRASS_BLUE,
	0.7,
	{
		deciduoustree = 6,
		evergreen = 6,
		wildbeaver_house = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		grass = 0.1,
		brown_mushroom = 0.1,
		fireflies = 0.4,
		spiderden = 0.05,
		cave_banana_tree = 0.02,
		rabbithole = 0.05,
	}
)

AddStandardRoom(
	"WaterBeaverForestHotspot",
	WORLD_TILES.GRASS_BLUE,
	0.7,
	{
		deciduoustree = 7,
		evergreen = 5,
		wildbeaver_house = 0.2,
		sapling = 0.1,
		twiggytree = 0.1,
		grass = 0.1,
		brown_mushroom = 0.3,
		fireflies = 0.8,
	}
)

AddStandardRoom(
	"WaterLureplantWall",
	WORLD_TILES.GRASS_BLUE,
	0.4,
	{
		pond = 0.05,
		deciduoustree = 5,
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
	},
	{
		lureplant = GetRandomFn(5, 4),
	},
	{},
	{},
	nil,
	{"ForceConnected"}
)

--[[
	Tier 3
--]]

AddStandardRoom(
	"WaterTreeRocks",
	WORLD_TILES.ROCKY,
	0.25,
	{
		evergreen_sparse = 1,
		rock1 = 0.05,
		rock_ice = 0.15,
	},
	{
		tallbirdnest = GetRandomFn(2, 2),
	}
)

AddStandardRoom(
	"WaterSpiderForest",
	WORLD_TILES.FOREST,
	0.8,
	{
		evergreen_sparse = 8,
		deciduoustree = 3,
		spiderden = 0.15,
		wildbeaver_house = 0.25,
		sapling = 0.1,
		twiggytree = 0.1,
		ground_twigs = 0.1,
	}
)

AddStandardRoom(
	"WaterMagicalForest",
	WORLD_TILES.FOREST,
	0.8,
	{
		evergreen_sparse = 7,
		deciduoustree = 2,
		wildbeaver_house = 0.1,
		pond_purple = 0.05,
		grass = 0.1,
		brown_mushroom = 0.3,
		rabbithole = 0.1,
	},
	{
		mandrake_planted = 3,
	}
)

AddStandardRoom(
	"WaterEvilForest",
	WORLD_TILES.FOREST,
	0.8,
	{
		evergreen_sparse = 8,
		wildbeaver_house = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		ground_twigs = 0.1,
	},
	{
		livingtree = 3,
		flower_evil = GetRandomFn(5, 5)
	}
)

AddStandardRoom(
	"WaterSuperMeadow",
	WORLD_TILES.GRASS_BLUE,
	0.2,
	{
		deciduoustree = 4,
		pond_purple = 0.3,
		beehive = 0.1,
		snake_hole = 0.1,
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		cave_banana_tree = 0.02,
		wildbore_house = 0.05,
	}
)

AddStandardRoom(
	"WaterWalrusMeadow",
	WORLD_TILES.GRASS_BLUE,
	0.15,
	{
		pond_purple = 0.1,
		snake_hole = 0.1,
		beehive = 0.05,
		rock_petrified_tree = 0.1,
	},
	{
		walrus_camp = 1,
	}
)

AddStandardRoom(
	"BGWaterBeach",
	WORLD_TILES.SAND,
	0.15,
	{
		sapling = 0.05,
		grass = 0.05,
		rocks = 0.1,
		flint = 0.1,
		palmtree = 0.1,
	}
)

AddStandardRoom(
	"WaterBeachEntrance",
	WORLD_TILES.SAVANNA,
	0.2,
	{
		rabbithole = 0.05,
		perma_grass = 0.2,
	}
)

AddStandardRoom(
	"WaterBeach",
	WORLD_TILES.SAND,
	0.15,
	{
		sapling = 0.05,
		grass = 0.05,
		palmtree = 0.1,
		wildbore_house = 0.05,
	},
	{
		crate = GetRandomFn(3, 5),
	}
)

AddStandardRoom(
	"WaterBeachRocks",
	WORLD_TILES.SAND,
	0.2,
	{
		sapling = 0.05,
		grass = 0.05,
		rock_limpet = 0.05,
		rock2 = 0.05,
		palmtree = 0.1,
	},
	{
		-- rocky = GetRandomFn(2, 3),
		walrus_camp = GetRandomFn(1, 1),
		crate = GetRandomFn(2, 2),
	}
)

AddStandardRoom(
	"WaterBeachSharkittens",
	WORLD_TILES.SAND,
	0.2,
	{
		ground_twigs = 0.1,
		rocks = 0.05,
		flint = 0.05,
		grass = 0.1,
	},
	{
		sharkittenspawner = GetRandomFn(3, 3),
	}
)

--[[
	Tier 4
--]]

AddStandardRoom(
	"WaterMooseLair",
	WORLD_TILES.GRASS_BLUE,
	0.3,
	{
		grass = 0.4,
		sapling = 0.3,
		twiggytree = 0.3,
		deciduoustree = 4,
		cave_banana_tree = 0.05,
	},
	{},
	{
		["MooseNest"] = 3,
	}
)

AddStandardRoom(
	"BGWaterMeanvers",
	WORLD_TILES.GRASS_BROWN,
	0.3,
	{
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.5,
		deciduoustree = 1,
		evergreen_sparse = 4,
		flower_evil = 0.1,
	}
)

AddStandardRoom(
	"WaterMeanvers",
	WORLD_TILES.GRASS_BROWN,
	0.3,
	{
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.5,
		evergreen_sparse = 4,
		deciduoustree = 3,
		wildmeanver_house = 0.1,
		brown_mushroom = 0.1,
		flower_evil = 0.3,
	}
)

AddStandardRoom(
	"WaterMooseLairTreasure",
	WORLD_TILES.GRASS_BLUE,
	0.2,
	{
		grass = 0.2,
		pond_purple = 0.1,
		deciduoustree = 5,
	},
	{},
	{
		["RewardMooseTreasure"] = 1,
	}
)

AddStandardRoom(
	"BGWaterMarsh",
	WORLD_TILES.MARSH,
	0.2,
	{
		reeds = 0.15,
		marsh_tree = 0.1,
		marsh_bush = 0.1,
	}
)

AddStandardRoom(
	"WaterMarsh",
	WORLD_TILES.MARSH,
	0.2,
	{
		reeds = 0.15,
		pond_mos = 0.1,
		tentacle = 0.5,
		marsh_tree = 0.1,
		marsh_bush = 0.1,
	}
)

AddStandardRoom(
	"WaterMarshSnakes",
	WORLD_TILES.MARSH,
	0.2,
	{
		reeds = 0.1,
		marsh_tree = 0.1,
		marsh_bush = 0.1,
		snake_hole = 0.4,
	}
)

AddStandardRoom(
	"WaterMarshTreasure",
	WORLD_TILES.MARSH,
	0.1,
	{
		reeds = 0.1,
		marsh_tree = 0.1,
		marsh_bush = 0.4,
		rock2 = 0.05,
	}
)

AddStandardRoom(
	"WaterBeeClearing",
	WORLD_TILES.GRASS_BLUE,
	-- WORLD_TILES.OCEAN_SHALLOW,
	0.1,
	{
		fireflies=0.01,
		flower=0.7,
		beehive=0.05,
	}
)

AddStandardRoom(
	"WaterBeeQueen",
	WORLD_TILES.GRASS_BLUE,
	0.45,
	{
		flower = 5,
		berrybush = 0.5,
		berrybush_juicy = 0.25,
		sapling = 0.2,
	},
	{
		beequeenhive = 1,
		beehive = 1,
		wasphive = function() return math.random(2) + 2 end,
	}
)
