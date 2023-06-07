AddTask("Slimey Island", {
    locks={LOCKS.ISLAND_TIER3},
    keys_given={},
    region_id = "slimey_island",
    level_set_piece_blocker = true,
    room_tags = {"RoadPoison", "not_mainland"},
    room_choices={
        ["Slimey Island Pig Village"] = 1,
        ["Slimey Island Swamp"] = 1,
    },
    room_bg=WORLD_TILES.SLIMEY,
    background_room = "BG Slimey Island",
    -- cove_room_name = "Empty_Cove",
    -- cove_room_chance = 1,
    -- cove_room_max_edges = 2,
    colour={r=.05,g=.5,b=.05,a=1},
})

AddTask("Snowy Island", {
    locks={LOCKS.ISLAND_TIER2},
    keys_given={},
    region_id = "snowy_island",
    level_set_piece_blocker = true,
    room_tags = {"RoadPoison", "not_mainland"},
    room_choices={
        ["Snowy Island Walrus Camp"] = 1,
        ["Snowy Island Bunny Village"] = 1,
        ["Snowy Island Yeti"] = 1,
        ["Snowy Island Pig Village"] = 1,
    },
    room_bg=WORLD_TILES.SNOWY,
    background_room = "BG Snowy Island",
    -- cove_room_name = "Empty_Cove",
    -- cove_room_chance = 1,
    -- cove_room_max_edges = 2,
    colour={r=.05,g=.5,b=.05,a=1},
})