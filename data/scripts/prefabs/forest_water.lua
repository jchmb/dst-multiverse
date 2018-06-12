require("prefabs/world")

local assets =
{
    Asset("SCRIPT", "scripts/prefabs/world.lua"),

    Asset("IMAGE", "images/colour_cubes/day05_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/dusk03_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/night03_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/snow_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/snowdusk_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/night04_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/summer_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/summer_dusk_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/summer_night_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/spring_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/spring_dusk_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/spring_night_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/insane_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/insane_dusk_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/insane_night_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/purple_moon_cc.tex"),

    Asset("ANIM", "anim/snow.zip"),
    Asset("ANIM", "anim/lightning.zip"),
    Asset("ANIM", "anim/splash_ocean.zip"),
    Asset("ANIM", "anim/frozen.zip"),

    Asset("SOUND", "sound/forest_stream.fsb"),
    Asset("SOUND", "sound/amb_stream.fsb"),

    Asset("IMAGE", "levels/textures/snow.tex"),
    Asset("IMAGE", "levels/textures/mud.tex"),
    Asset("IMAGE", "images/wave.tex"),
}

local prefabs =
{
    "cave",
    "deer",
    "deerspawningground",
    "forest_water_network",
    "adventure_portal",
    "resurrectionstone",
    "deerclops",
    "gravestone",
    "flower",
    "animal_track",
    "dirtpile",
    "beefaloherd",
    "beefalo",
    "penguinherd",
    "penguin_ice",
    "penguin",
    "koalefant_summer",
    "koalefant_winter",
    "beehive",
    "wasphive",
    "walrus_camp",
    "pighead",
    "mermhead",
    "rabbithole",
    "molehill",
    "beemine_maxwell",
   "trap_teeth_maxwell",
   "sculpture_knight",
   "sculpture_bishop",
   "sculpture_rook",
   "statue_marble",
   "eyeplant",
    "carrot_planted",
    "tentacle",
    "wormhole",
    "cave_entrance",
    "teleportato_base",
    "teleportato_ring",
    "teleportato_box",
    "teleportato_crank",
    "teleportato_potato",
    "pond",
    "marsh_tree",
    "marsh_bush",
    "burnt_marsh_bush",
    "reeds",
    "mist",
    "snow",
    "rain",
    "pollen",
    "marblepillar",
    "marbletree",
    "statueharp",
    "statuemaxwell",
    "eyeplant",
    "lureplant",
    "purpleamulet",
    "monkey",
    "livingtree",
    "tumbleweed",
    "rock_ice",
    "catcoonden",
    "shadowmeteor",
    "meteorwarning",
    "warg",
    "claywarg",
    "spat",
    "multiplayer_portal",
    "lavae",
    "lava_pond",
    "scorchedground",
    "scorched_skeleton",
    "lavae_egg",
    "terrorbeak",
    "crawlinghorror",
    "creepyeyes",
    "shadowskittish",
    "shadowwatcher",
    "shadowhand",
    "rubble",
    "tumbleweedspawner",
    "meteorspawner",
    "dragonfly_spawner",
    "moose",
    "mossling",
    "bearger",
    "dragonfly",
    "chester",
    "grassgekko",
    "petrify_announce",
    "moonbase",
    "moonrock_pieces",
    "shadow_rook",
    "shadow_knight",
    "shadow_bishop",
    "beequeenhive",
    "klaus_sack",
    "antlion_spawner",
    "oasislake",
    "succulent_plant",
    "stagehand",
}

local monsters =
{
    "worm",
}
for i, v in ipairs(monsters) do
    for level = 1, 4 do
        table.insert(prefabs, v.."warning_lvl"..tostring(level))
    end
end
monsters = nil

local assets =
{
    Asset("SCRIPT", "scripts/prefabs/world.lua"),

    Asset("SOUND", "sound/cave_AMB.fsb"),
    Asset("SOUND", "sound/cave_mem.fsb"),
    Asset("IMAGE", "images/colour_cubes/caves_default.tex"),

    Asset("IMAGE", "images/colour_cubes/ruins_light_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/ruins_dim_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/ruins_dark_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/fungus_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/sinkhole_cc.tex"),
}

local wormspawn =
{
    base_prefab = "crocodog",
    winter_prefab = "crocodog",
    summer_prefab = "crocodog",

    attack_levels =
    {
        intro   = { warnduration = function() return 120 end, numspawns = function() return 1 end },
        light   = { warnduration = function() return 60 end, numspawns = function() return 1 + math.random(0,1) end },
        med     = { warnduration = function() return 45 end, numspawns = function() return 1 + math.random(0,1) end },
        heavy   = { warnduration = function() return 30 end, numspawns = function() return 2 + math.random(0,1) end },
        crazy   = { warnduration = function() return 30 end, numspawns = function() return 3 + math.random(0,2) end },
    },

    attack_delays =
    {
        rare        = function() return TUNING.TOTAL_DAY_TIME * 10, math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
        occasional  = function() return TUNING.TOTAL_DAY_TIME * 8, math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
        frequent    = function() return TUNING.TOTAL_DAY_TIME * 6, math.random() * TUNING.TOTAL_DAY_TIME * 5 end,
    },

    warning_speech = "ANNOUNCE_HOUNDS",

    --Key = time, Value = sound prefab
    warning_sound_thresholds =
    {
        { time = 30, sound = "wormwarning_lvl4" },
        { time = 60, sound = "wormwarning_lvl3" },
        { time = 90, sound = "wormwarning_lvl2" },
        { time = 500, sound = "wormwarning_lvl1" },
    },
}

local function common_postinit(inst)
    --Add waves
    inst.entity:AddWaveComponent()
    inst.WaveComponent:SetWaveParams(13.5, 2.5)						-- wave texture u repeat, forward distance between waves
    inst.WaveComponent:SetWaveSize(80, 3.5)							-- wave mesh width and height
    inst.WaveComponent:SetWaveTexture("images/wave.tex")
    --See source\game\components\WaveRegion.h
    inst.WaveComponent:SetWaveEffect("shaders/waves.ksh")
    --inst.WaveComponent:SetWaveEffect("shaders/texture.ksh")

    --Initialize lua components
    inst:AddComponent("ambientlighting")

    --Dedicated server does not require these components
    --NOTE: ambient lighting is required by light watchers
    if not TheNet:IsDedicated() then
        inst:AddComponent("dynamicmusic")
        inst:AddComponent("ambientsound")
        inst:AddComponent("dsp")
        inst:AddComponent("colourcube")
        inst:AddComponent("hallucinations")
    end
end

local function master_postinit(inst)
    --Spawners
    --inst:AddComponent("flowerspawner")
    inst:AddComponent("birdspawner")
    inst:AddComponent("butterflyspawner")
    inst:AddComponent("hounded")

    inst.components.hounded:SetSpawnData(wormspawn)

    inst:AddComponent("worlddeciduoustreeupdater")
    inst:AddComponent("kramped")
    inst:AddComponent("frograin")
    inst:AddComponent("penguinspawner")
    inst:AddComponent("deerclopsspawner")
    inst:AddComponent("beargerspawner")

    inst:AddComponent("perma_moosespawner")
    inst.components.perma_moosespawner:InitializeNests()

    inst:AddComponent("worlddeciduoustreeupdater")
    inst:AddComponent("kramped")
    inst:AddComponent("frograin")
    inst:AddComponent("penguinspawner")
    inst:AddComponent("deerherdspawner")
    inst:AddComponent("deerherding")
    inst:AddComponent("deerclopsspawner")
    inst:AddComponent("beargerspawner")
    inst:AddComponent("moosespawner")
    inst:AddComponent("hunter")
    inst:AddComponent("perma_lureplantspawner")
    inst:AddComponent("shadowcreaturespawner")
    inst:AddComponent("shadowhandspawner")
    inst:AddComponent("wildfires")
    inst:AddComponent("worldwind")
    inst:AddComponent("forestresourcespawner")
    inst:AddComponent("regrowthmanager")
    inst:AddComponent("desolationspawner")
    inst:AddComponent("forestpetrification")
    inst:AddComponent("chessunlocks")
    inst:AddComponent("retrofitforestmap_anr")
    inst:AddComponent("specialeventsetup")
    inst:AddComponent("townportalregistry")
    inst:AddComponent("sandstorms")

    if METRICS_ENABLED then
        inst:AddComponent("worldoverseer")
    end

    -- inst:AddComponent("periodicthreat")
    -- local threats = require"periodicthreats"
    -- inst.components.periodicthreat:AddThreat("WORM", threats["WORM"])
end

return MakeWorld("forest_water", prefabs, assets, common_postinit, master_postinit, {"forest_water"})
