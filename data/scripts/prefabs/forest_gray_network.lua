local MakeWorldNetwork = require("prefabs/world_network")

local assets = {
    Asset("SCRIPT", "scripts/prefabs/world_network.lua"),
}

local prefabs =
{
    "thunder_close",
    "thunder_far",
    "lightning",
}

local function custom_postinit(inst)
    inst:AddComponent("weather")
    inst:AddComponent("nightmareclock")
end

return MakeWorldNetwork("forest_gray_network", prefabs, assets, custom_postinit)
