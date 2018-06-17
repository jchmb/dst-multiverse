AddLocationWrapped("Bunnyland", {
    location = "forest_bunnyland",
    version = 2,
    overrides={
        start_location = "bunnyland",
        season_start = "default",
        world_size = "default",
        task_set = "default",
        layout_mode = "LinkNodesByKeys",
        wormhole_prefab = "wormhole",
        roads = "default",
    },
    required_prefabs = {
        "multiplayer_portal",
    },
})
