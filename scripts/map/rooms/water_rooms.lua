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

AddStandardRoom(
	"BGWater",
	GROUND.GRASS_BLUE,
	0.15,
	{
		cave_banana_tree = 0.005,
		evergreen = 5,
		blue_mushroom = 0.1,
		fireflies = 1,
		sapling = 0.1,
		twiggytree = 0.1,
		grass = 0.1,
	}
)

--[[
	Tier 0
--]]

AddStandardRoom(
	"WaterClearing",
	GROUND.GRASS_BLUE,
	0.3,
	{
		evergreen = 2,
		deciduoustree = 1,
		cave_banana_tree = 0.007,
		fireflies = 0.5,
		grass = 0.1,
	},
	{
		multiplayer_portal = 1,
	}
)

AddStandardRoom(
	"WaterForest",
	GROUND.FOREST,
	0.65,
	{
		evergreen = 6,
		deciduoustree = 4,
		cave_banana_tree = 0.007,
		fireflies = 0.5,
		ground_twigs = 0.1,
		blue_mushroom = 0.1,
		green_mushroom = 0.1,
		grass = 0.2,
		wildbeaver_house = 0.05,
	}
)

AddStandardRoom(
	"WaterRocks",
	GROUND.ROCKY,
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
	"WaterMonkeyForest",
	GROUND.FOREST,
	0.3,
	{
		evergreen = 6,
		deciduoustree = 4,
		cave_banana_tree = 0.01,
		fireflies = 0.5,
		ground_twigs = 0.1,
		blue_mushroom = 0.1,
		green_mushroom = 0.1,
		grass = 0.2,
		monkeybarrel = 0.03,
	}
)

AddStandardRoom(
	"WaterMeadow",
	GROUND.GRASS_BLUE,
	0.2,
	{
		pond_purple = 0.05,
		grass = 0.1,
		sapling = 0.1,
		twiggytree = 0.1,
		beehive = 0.05,
		flower = 2,
		deciduoustree = 0.5,
		rock1 = 0.05,
	}
)

--[[
	Beaver King
--]]
AddRoom("WaterBeaverKingdom", {
	colour={r=0.8,g=.8,b=.1,a=.50},
	value = GROUND.GRASS_BLUE,
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
		}
	}
})

--[[
	Tier 2
--]]

AddStandardRoom(
	"WaterMeadowMerms",
	GROUND.GRASS_BLUE,
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
	GROUND.SAVANNA,
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
	GROUND.GRASS_BLUE,
	0.8,
	{
		deciduoustree = 6,
		evergreen = 6,
		wildbeaver_house = 0.2,
		sapling = 0.1,
		twiggytree = 0.1,
		grass = 0.1,
		blue_mushroom = 0.1,
		green_mushroom = 0.1,
		fireflies = 0.5,
		spiderden = 0.05,
		cave_banana_tree = 0.02,
	}
)

AddStandardRoom(
	"WaterLureplantWall",
	GROUND.GRASS_BLUE,
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
	}
)

--[[
	Tier 3
--]]

AddStandardRoom(
	"WaterTreeRocks",
	GROUND.ROCKY,
	0.25,
	{
		evergreen_sparse = 1,
		rock_petrified_tree = 0.3,
		rock2 = 0.05,
		rock_ice = 0.05,
		wildbeaver_house = 0.1,
	}
)

AddStandardRoom(
	"WaterSpiderForest",
	GROUND.FOREST,
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
	GROUND.FOREST,
	0.8,
	{
		evergreen_sparse = 7,
		deciduoustree = 2,
		wildbeaver_house = 0.1,
		pond_purple = 0.05,
		grass = 0.1,
		green_mushroom = 0.3,
		blue_mushroom = 0.3,
	},
	{
		mandrake = 3,
	}
)

AddStandardRoom(
	"WaterEvilForest",
	GROUND.FOREST,
	0.8,
	{
		evergreen_sparse = 8
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