local default_tasks = {
	"Make a pick modified",
	"Dig that rock",
	"Great Plains",
	"Squeltch",
	"Beeeees!",
	"Forest hunters",
	"For a nice walk",
}

AddTaskSet("default_modified", {
		name = "Default with migration portals",
        location = "forest",
		tasks = default_tasks,
		numoptionaltasks = 0,
        valid_start_tasks = {
            "Make a pick modified",
        },
		set_pieces = {
			["ResurrectionStone"] = { count = 2, tasks=default_tasks },
			["WormholeGrass"] = { count = 6, tasks=default_tasks},
			["CaveEntrance"] = { count = 7, tasks=default_tasks},
			--["CaveEntrance"] = { count = 7, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs"} },
		},
	})

AddTask("Make a pick modified", {
		locks=LOCKS.NONE,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1},
		room_choices={
			["ForestModified"] = 1,
			["BarePlainModified"] = 1,
			["PlainModified"] = 1,
			["Clearing"] = 1,
		},
		room_bg=GROUND.GRASS,
		background_room="BGGrass",
		colour={r=0,g=1,b=0,a=1}
	})

AddRoom("ForestModified", {
					colour={r=.5,g=0.6,b=.080,a=.10},
					value = GROUND.FOREST,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
									countprefabs = {
										migration_portal = 3,
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
										twiggytree = 0.8,
										ground_twigs = 0.06,
										--rabbithole=.05,
					                    berrybush=.03,
					                    berrybush_juicy = 0.015,
					                    red_mushroom = .03,
					                    green_mushroom = .02,
										trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}}
					                },
					            }
					})

AddRoom("PlainModified", {
					colour={r=.8,g=.4,b=.4,a=.50},
					value = GROUND.SAVANNA,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
									countprefabs = {
										migration_portal = 3,
									},
					                distributepercent = .2,
					                distributeprefabs=
					                {
					                	rock_petrified_tree = 0.15,
					                    rock1 = 0.05,
					                    perma_grass = 0.5,
					                    rabbithole= 0.25,
					                    green_mushroom = .005,
					                },
					            }
					})
AddRoom("BarePlainModified", {					colour={r=.5,g=.5,b=.45,a=.50},
					value = GROUND.SAVANNA,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
									countprefabs = {
										migration_portal = 3,
									},
					                distributepercent = 0.1,
					                distributeprefabs=
					                {
					                    perma_grass = 0.8,
					                    rabbithole=0.4,
--					                    beefalo=0.2
					                },
					            }
					})
