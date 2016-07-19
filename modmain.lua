-- General globals
STRINGS = GLOBAL.STRINGS

-- Recipe globals
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe

Assets = {
	-- Snow tiles
	Asset("IMAGE", "levels/textures/noise_snowy.tex"),
	Asset("IMAGE", "levels/textures/mini_noise_snowy.tex"),
	Asset("IMAGE", "levels/tiles/snowy.tex"),
	Asset("FILE", "levels/tiles/snowy.xml"),

	-- Slimey tiles
	Asset("IMAGE", "levels/textures/noise_slimey.tex"),
	Asset("IMAGE", "levels/textures/mini_noise_slimey.tex"),
	Asset("IMAGE", "levels/tiles/slimey.tex"),
	Asset("FILE", "levels/tiles/slimey.xml"),

	-- Assets for recipes
	Asset("IMAGE", "images/inventoryimages/pighouse_yellow.tex" ),
	Asset("ATLAS", "images/inventoryimages/pighouse_yellow.xml" ),
	Asset("IMAGE", "images/inventoryimages/pighouse_blue.tex" ),
	Asset("ATLAS", "images/inventoryimages/pighouse_blue.xml" ),
	Asset("IMAGE", "images/inventoryimages/pighouse_gray.tex" ),
	Asset("ATLAS", "images/inventoryimages/pighouse_gray.xml" ),

	-- Items
	Asset("IMAGE", "images/inventoryimages/dug_coffeebush.tex" ),
	Asset("ATLAS", "images/inventoryimages/dug_coffeebush.xml" ),
	Asset("IMAGE", "images/inventoryimages/coffeebeans.tex" ),
	Asset("ATLAS", "images/inventoryimages/coffeebeans.xml" ),
	Asset("IMAGE", "images/inventoryimages/coffeebeans_cooked.tex" ),
	Asset("ATLAS", "images/inventoryimages/coffeebeans_cooked.xml" ),
	Asset("IMAGE", "images/inventoryimages/coffee.tex" ),
	Asset("ATLAS", "images/inventoryimages/coffee.xml" ),

	-- Turfs
	Asset("IMAGE", "images/inventoryimages/turf_snowy.tex" ),
	Asset("ATLAS", "images/inventoryimages/turf_snowy.xml" ),
	Asset("IMAGE", "images/inventoryimages/turf_slimey.tex" ),
	Asset("ATLAS", "images/inventoryimages/turf_slimey.xml" ),

	-- Minimap icons
	Asset("MINIMAP_IMAGE", "teleportato"),
	Asset("MINIMAP_IMAGE", "map_icons/minimap_coffeebush.tex"),
}

--[[
	Ground definitions
--]]

PrefabFiles = {
	-- Location prefabs
	"forest_snow",
	"forest_snow_network",

	-- Bluepig prefabs
	"pigman_blue",
	"pighouse_blue",
	"pigking_blue",

	-- Yellowpig prefabs
	"pigman_yellow",
	"pighouse_yellow",

	-- Graypigs prefabs
	"pigman_gray",
	"pighouse_gray",
	"pigking_gray",

	-- Snow mobs and spawners
	"rabbithole_snow",
	"rabbit_snow",
	"leif_snow",
	"pond_open",
	"reingoat",
	"reingoatherd",
	"perma_walrus_camp",
	
	-- Misc
	"new_turfs",
	"new_plantables",
	"new_bushes",
	"new_veggies",
	"coffee",
}

--[[
	Some new names
--]]

-- Prefabs
STRINGS.NAMES.TURF_SNOWY = "Snowy Turf"
STRINGS.NAMES.TURF_SLIMEY = "Slimey Turf"
STRINGS.NAMES.PIGKING_GRAY = "Graypig King"
STRINGS.NAMES.PIGKING_BLUE = "Chillpig King"
STRINGS.NAMES.PIGHOUSE_BLUE = "Chillpig House"
STRINGS.NAMES.PIGHOUSE_YELLOW = "Yellowpig House"
STRINGS.NAMES.PIGHOUSE_GRAY = "Graypig House"
STRINGS.NAMES.RABBIT_SNOW = "Snow Rabbit"
STRINGS.NAMES.RABBITHOLE_SNOW = "Rabbithole"
STRINGS.NAMES.LEIF_SNOW = "Jolly Treeguard"
STRINGS.NAMES.POND_OPEN = "Pond"
STRINGS.NAMES.REINGOAT = "Reingoat"
STRINGS.NAMES.PERMA_WALRUS_CAMP = "Elite Walrus Camp"

-- Items
STRINGS.NAMES.DUG_COFFEEBUSH = "Dug Coffeebush"
STRINGS.NAMES.COFFEEBUSH = "Coffeebush"
STRINGS.NAMES.COFFEEBEANS = "Coffeebeans"
STRINGS.NAMES.COFFEEBEANS_COOKED = "Cooked Coffeebeans"
STRINGS.NAMES.COFFEE = "Coffee"

-- World names
STRINGS.NAMES.MULTIWORLD_CUTE = "Bunny World"
STRINGS.NAMES.MULTIWORLD_GRAY = "Grayscale World"
STRINGS.NAMES.MULTIWORLD_SLIMEY = "Slimey World"
STRINGS.NAMES.MULTIWORLD_SNOWY = "Snow World"
STRINGS.NAMES.MULTIWORLD_CHEZZ = "Chezz World"

--[[
	Import some chatter files
--]]

modimport("scripts/chatter/pigman_blue_chat.lua")
modimport("scripts/chatter/pigman_gray_chat.lua")

--[[
	Recipes
--]]
modimport("cookpot_recipes.lua")

--[[
	Prefab descriptions
--]]
modimport("prefab_descriptions.lua")

--[[
	Minimap icons
--]]
modimport("minimap_icons.lua")

--[[
	Yellow Pighouse Recipe
--]]
local pighouseYellowRecipe = Recipe(
	"pighouse_yellow",
	{
		Ingredient("boards", 4),
		Ingredient("pigskin", 4),
		Ingredient("phlegm", 7),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_yellow_placer"
)
pighouseYellowRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_yellow.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_YELLOW = "Houses one yellowpig"

--[[
	Blue Pighouse Recipe
--]]
local pighouseBlueRecipe = Recipe(
	"pighouse_blue",
	{
		Ingredient("boards", 4),
		Ingredient("cutstone", 3),
		Ingredient("pigskin", 3),
		Ingredient("ice", 10),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_blue_placer"
)
pighouseBlueRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_blue.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_BLUE = "Houses one chillpig"


--[[
	Gray Pighouse Recipe
--]]
local pighouseGrayRecipe = Recipe(
	"pighouse_gray",
	{
		Ingredient("boards", 4),
		Ingredient("cutstone", 3),
		Ingredient("pigskin", 3),
		Ingredient("nightmarefuel", 3),
	},
	RECIPETABS.TOWN,
	TECH.LOST,
	"pighouse_gray_placer"
)
pighouseGrayRecipe.atlas = GLOBAL.resolvefilepath("images/inventoryimages/pighouse_gray.xml")
STRINGS.RECIPE_DESC.PIGHOUSE_GRAY = "Houses one graypig"

--[[
	Adapting some existing prefabs
--]]

-- Migration portals share the wormhole icon. This is confusing. Use teleportato icon instead.
AddPrefabPostInit("migration_portal", function(prefab)
	prefab.MiniMapEntity:SetIcon("teleportato.png")
end)