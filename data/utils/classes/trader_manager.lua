local _G = GLOBAL
local CUSTOM_RECIPETABS = _G.CUSTOM_RECIPETABS
local TECH = _G.TECH
local STRINGS = _G.STRINGS

TraderManager = Class(function(self, name, atlas, image)
    self.tab = AddRecipeTab(
        name,
        10,
        atlas or "images/inventoryimages.xml",
        image or "quagmire_coin1.tex",
        nil,
        true
    )
    self.tab.shop = true
    -- AddNewTechTree(name, 3)
    self.tech = TECH[name .. "_THREE"]
    _G.STRINGS.TABS[name] = "Trading"
end)

function TraderManager:Add(prefab, cost, description, atlas, image, numtogive, productdescr)
    local recipe = AddTraderItem(
        prefab .. "_trading",
        cost,
        self.tab,
        self.tech,
        description,
        atlas,
        image,
        numtogive,
        true
    )
    recipe.product = prefab

    -- Dirty copy trick. Pretend you didn't see this.
    if productdescr then
        STRINGS.RECIPE_DESC[string.upper(prefab)] = description
        STRINGS.NAMES[string.upper(prefab) .. "_trading"] = STRINGS.NAMES[string.upper(prefab)]
    end
end

return TraderManager
