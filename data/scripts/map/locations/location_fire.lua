AddLocationWrapped("Fire", {
    location = "forest_fire",
    version = 2,
    overrides={
        start_location = "default",
        season_start = "summer",
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
