local Layouts = GLOBAL.require("map/layouts").Layouts
Layouts["MultiBeachStart"] = GLOBAL.require("map/layouts/multi_beach_start")

AddStartLocation("multi_beach", {
    name = "Beach Start",
    location = "forest",
    start_setpeice = "MultiBeachStart",
    start_node = "MultiBeachClearing",
})