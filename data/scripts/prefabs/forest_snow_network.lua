local MakeWorldNetwork = require("prefabs/world_network")

-- t' =  0.75 * t - 3
local SNOWY_WORLD_TEMP_MODIFIER = 0.2
local SNOWY_WORLD_TEMP_LOCUS = -12

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
    inst.components.worldtemperature:SetTemperatureMod(SNOWY_WORLD_TEMP_MODIFIER, SNOWY_WORLD_TEMP_LOCUS)
end

return MakeWorldNetwork("forest_snow_network", prefabs, assets, custom_postinit)
