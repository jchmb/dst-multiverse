local MakeWorldNetwork = require("prefabs/world_network")

local FIRE_WORLD_TEMP_MODIFIER = 1.6
local FIRE_WORLD_TEMP_LOCUS = 5

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
    inst.components.worldtemperature:SetTemperatureMod(FIRE_WORLD_TEMP_MODIFIER, FIRE_WORLD_TEMP_LOCUS)
end

return MakeWorldNetwork("forest_fire_network", prefabs, assets, custom_postinit)
