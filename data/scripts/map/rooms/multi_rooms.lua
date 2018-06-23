AddStandardRoom(
	"MultiBeachClearing",
	GROUND.SAND,
	0.1,
	{
		sapling = 0.05,
		twiggytree = 0.05,
		grass = 0.05,
	},
	{
		spawnpoint_multiplayer = 1,
		seashell_beached = GetRandomFn(5, 3),
	}
)

AddStandardRoom(
	"BGMultiBeach",
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
	"MultiBeach",
	GROUND.SAND,
	0.2,
	{
		sapling = 0.1,
		twiggytree = 0.1,
		ground_twigs = 0.05,
		grass = 0.125,
		grassgekko = 0.05,
		palmtree = 1,
		flint = 0.1,
		rock_limpet = 0.15,
		wildbore_house = 0.05,
		seashell_beached = 0.1,
		sandhill = 0.1,
	}
)

AddStandardRoom(
	"MultiHerds",
	GROUND.SAVANNA,
	0.3,
	{
		perma_grass = 0.2,
		bunneefalo = 0.01,
		beefalo = 0.01,
		rabbithole = 0.025,
		mushtree_medium = 0.025,
	}
)

AddStandardRoom(
	"BGMultiRocks",
	GROUND.ROCKY,
	0.2,
	{
		rock1 = 0.1,
		rock2 = 0.1,
		grassgekko = 0.1,
		flint = 0.1,
		rocks = 0.05,
	}
)

AddStandardRoom(
	"MultiRocks",
	GROUND.ROCKY,
	0.2,
	{
		rock1 = 0.1,
		rock2 = 0.1,
		grassgekko = 0.1,
		flint = 0.1,
		rocks = 0.05,
	},
	{
		meteorspawner = 1,
	}
)
