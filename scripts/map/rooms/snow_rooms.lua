local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
Layouts["PigKingBlue"] = StaticLayout.Get(
	"map/static_layouts/default_pigking_blue",
	{
		start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
		layout_position = GLOBAL.LAYOUT_POSITION.CENTER
	}
)

--[[
	Background Rooms
--]]

AddRoom("BGSnowy", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			rock_ice = 0.05,
			mintybush = 0.15,
			carrot_planted = 0.1,
			sapling = 0.2,
			twiggytree = 0.15,
			grass = 0.1,
			flower = 1,
			evergreen = 2,
			rabbithole_snow = 0.1,
			red_mushroom = 0.05,
			green_mushroom = 0.05,
			blue_mushroom = 0.05,
		}
	}
})

AddRoom("BGSnowyForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.7,
		distributeprefabs = {
			sapling = 0.1,
			twiggytree = 0.1,
			grass = 0.1,
			evergreen = 6,
			evergreen_sparse = 3,
			red_mushroom = 0.05,
			green_mushroom = 0.05,
			blue_mushroom = 0.05,
			flower = 0.5,
			mintybush = 0.1,
		}
	}
})

--[[
	Tier 0
--]]

AddRoom("SnowyPlain", {
	colour={r=.5,g=.5,b=.45,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.1,
		distributeprefabs= {
			rock_petrified_tree = 0.15,
			rock1 = 0.05,
			perma_grass = 0.5,
			perma_grass = 0.5,
			rabbithole_snow=0.25,
			rock_ice = 0.2,
		},
	}
})

AddRoom("SnowyBarePlain", {
	colour={r=.5,g=.5,b=.45,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.1,
		distributeprefabs= {
			perma_grass = 0.8,
			rabbithole_snow=0.4,
			rock_ice = 0.2,
		},
	}
})

--[[
	Tier 1
--]]
AddRoom("SnowyHerds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.2,
		distributeprefabs = {
			beefalo = 0.1,
			perma_grass = 0.1,
			flower = 1,
			rabbithole_snow = 0.05,
			rock_ice = 0.1,
		}
	}
})

AddRoom("SnowyKoalefants", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SAVANNA,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.2,
		countprefabs = {
			koalefant_winter = 4,
		},
		distributeprefabs = {
			perma_grass = 0.2,
			flower = 1,
			rabbithole_snow = 0.05,
		}
	}
})

AddRoom("SnowyRocks", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		countprefabs = {
			meteorspawner = 1,
		},
		distributeprefabs = {
			rock1 = 0.1,
			rock2 = 0.1,
			rock_ice = 0.4,
			flint = 0.1,
		}
	}
})

AddRoom("SnowyGraveyard", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone", "Mist"},
	contents =  {
		distributepercent = 0.15,
		countprefabs = {
			meteorspawner = 1,
			gravestone = 9,
			skeleton = 2,
			mound = 11,
		},
		distributeprefabs = {
			evergreen_sparse = 5,
			flower_evil = 0.2,
			rock1 = 0.2,
		}
	}
})


--[[
	PK Biome
--]]

AddRoom("BGSnowyDeciduous", {
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

			sapling=0.1,
			grass=0.1,						

			flower=0.75,

			red_mushroom = 0.1,
			blue_mushroom = 0.1,
			green_mushroom = 0.1,

			mintybush=0.05,
			carrot_planted = 0.2,

			fireflies = 0.5,

			pighouse_blue = 0.02,
		},
	}
})

AddRoom("SnowyMagicalDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countstaticlayouts={
			["DeciduousPond"] = 1,
		},
		distributepercent = .3,
		distributeprefabs={
			grass =0.1,
			sapling=0.1,

			red_mushroom = 2,
			blue_mushroom = 2,
			green_mushroom = 2,

			molehill = 2,
			catcoonden = .25,

			mintybush = 3,

			fireflies = 2,
			rock_ice = 0.2,
		},
	}
})

AddRoom("SnowyDeepDeciduous", {
	colour={r=0,g=.9,b=0,a=.50},
	value = GROUND.DECIDUOUS,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = .4,
		distributeprefabs={
			grass =0.1,
			sapling=0.1,

			deciduoustree = 10,
			catcoonden = .05,

			red_mushroom = 0.15,
			blue_mushroom = 0.15,
			green_mushroom = 0.15,

			fireflies = 2,

			rock_ice = 0.5,
			pighouse_blue = 0.1,
		},
	}
})

AddRoom("SnowyPigKingdom", {
	colour={r=0.8,g=.8,b=.1,a=.50},
	value = GROUND.GRASS,
	tags = {"Town"},
	required_prefabs = {"pigking_blue"},
	contents =  {
		countstaticlayouts={
			["PigKingBlue"]=1,
			["CropCircle"]=function() return math.random(0,1) end,
			["TreeFarm"]= 	function()
								if math.random() > 0.97 then 
									return math.random(1,2) 
								end 
								return 0 
							end,
		},
		countprefabs= {
			pighouse_blue = function () return 5 + math.random(4) end,
		}
	}
})

--[[
	Tier 2
--]]

AddRoom("BGSnowyIcedLake", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone", "RoadPoison"},
	contents =  {
		distributepercent = 0.6,
		distributeprefabs = {
			evergreen = 9,
		}
	}
})

AddRoom("SnowyIcedLake", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ICE_LAKE,
	internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	tags = {"ExitPiece", "Chester_Eyebone", "RoadPoison"},
	contents =  {
		distributepercent = 0.1,
		distributeprefabs = {
			pond_open = 0.03,
			houndbone = 0.09,
			rock_ice = 0.16,
			flint = 0.03,
		}
	}
})

AddRoom("SnowyIcedLakeWalrus", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ICE_LAKE,
	internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	tags = {"ExitPiece", "Chester_Eyebone", "RoadPoison"},
	contents =  {
		distributepercent = 0.1,
		countprefabs = {
			perma_walrus_camp = 1,
		},
		distributeprefabs = {
			pond_open = 0.05,
		}
	}
})

AddRoom("SnowyIcedLakeHounds", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ICE_LAKE,
	internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	tags = {"ExitPiece", "Chester_Eyebone", "RoadPoison"},
	contents =  {
		distributepercent = 0.1,
		countprefabs = {
			houndmound = 2,
		},
		distributeprefabs = {
			pond_open = 0.05,
			houndbone = 0.15,
			rock1 = 0.09,
			rock2 = 0.05,
		}
	}
})

AddRoom("SnowyForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.6,
		distributeprefabs = {
			sapling = 0.1,
			grass = 0.1,
			ground_twigs = 0.2,
			evergreen = 7,
			evergreen_sparse = 2,
			red_mushroom = 0.2,
			green_mushroom = 0.2,
			blue_mushroom = 0.2,
			pighouse_blue = 0.02,
			fireflies = 0.2,
			catcoonden = 0.01,
		}
	}
})

AddRoom("SnowyGoats", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.6,
		countprefabs = {
			reingoat = 7,
			migration_portal = 1,
		},
		distributeprefabs = {
			perma_grass = 0.2,
			evergreen = 3,
			evergreen_sparse = 2,
			rock1 = 0.15,
			rock_ice = 0.3,
		}
	}
})

AddRoom("SnowyLeifForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		countprefabs = {
			migration_portal = 1,
		},
		distributepercent = 0.3,
		distributeprefabs = {
			sapling = 0.1,
			grass = 0.1,
			evergreen = 5,
			evergreen_sparse = 2,
			fireflies = 1,
			leif_snow = 0.1,
		}
	}
})

AddRoom("SnowyTotallyNormalForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.7,
		distributeprefabs = {
			sapling = 0.1,
			grass = 0.1,
			evergreen = 5,
			evergreen_sparse = 4,
			fireflies = 1,
			leif_snow = 0.1,
			flower_evil = 0.3,
			livingtree = 0.05,
		}
	}
})


--[[
	Tier 3
--]]

AddRoom("SnowyTallbirdForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.3,
		distributeprefabs = {
			ground_twigs = 0.2,
			evergreen = 8,
			evergreen_sparse = 4,
			tallbirdnest = 0.2,
			fireflies = 1,
			rock2 = 0.1,
		}
	}
})

AddRoom("SnowySpiderForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.8,
		distributeprefabs = {
			gravestone = 0.1,
			ground_twigs = 0.2,
			evergreen = 3,
			evergreen_sparse = 5,
			spiderden = 0.15,
		}
	}
})

AddRoom("SnowyWalrusForest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.3,
		countprefabs = {
			perma_walrus_camp = 1,
			skeleton = 4,
		},
		distributeprefabs = {
			evergreen = 3,
			evergreen_sparse = 5,
			grass = 0.3,

		}
	}
})

--[[
	Tier 4
--]]

AddRoom("SnowyHoundNest", {
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.SNOWY,
	tags = {"ExitPiece", "Chester_Eyebone"},
	contents =  {
		distributepercent = 0.15,
		countprefabs = {
			thulecite_pieces = 1,
			bluegem = 1,
			icehound = 1,
			houndmound = 3,
		},
		distributeprefabs = {
			rocks = 0.2,
			evergreen = 2,
			houndbone = 0.4,
		}
	}
})