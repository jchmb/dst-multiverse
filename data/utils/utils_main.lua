local AllRecipes = GLOBAL.AllRecipes
local TraderProducts = {}
local cooking = GLOBAL.require("cooking")

GLOBAL.global("jchmb")
GLOBAL.jchmb = {}

GLOBAL.jchmb.IsInstanceOf = function(obj, cls)
	return (obj.prefab ~= nil and obj.prefab == cls) or
		(obj.name ~= nil and obj.name == cls)
end

GLOBAL.jchmb.IsOneOf = function(obj, classes)
	for i,cls in ipairs(classes) do
		if GLOBAL.jchmb.IsInstanceOf(obj, cls) then
			return true
		end
	end
	return false
end

GLOBAL.jchmb.SpawnPrefabAtOwner = function(owner, prefab)
	SpawnPrefab(prefab).Transform:SetPosition(owner.Transform:GetWorldPosition())
end

GLOBAL.jchmb.MakeObsidianTool = function(inst, tooltype)
    inst:AddTag("obsidian")
    inst:AddTag("notslippery")
    inst.no_wet_prefix = true

    -- if inst.components.floatable then
    --     inst.components.floatable:SetOnHitWaterFn(function(inst)
    --         inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/obsidian_wetsizzles")
    --         inst.components.obsidiantool:SetCharge(0)
    --     end)
    -- end

    -- inst:AddComponent("obsidiantool")
    -- inst.components.obsidiantool.tool_type = tooltype

    -- if not inst.components.heater then
    --     --only hook up heater to obsidiantool if the heater isn't already on.
    --     inst:AddComponent("heater")
    --     inst.components.heater.show_heat = true
	--
    --     inst.components.heater.heatfn = GetObsidianHeat
    --     inst.components.heater.minheat = 0
    --     inst.components.heater.maxheat = TUNING.OBSIDIAN_TOOL_MAXHEAT
	--
    --     inst.components.heater.equippedheatfn = GetObsidianEquippedHeat
    --     --inst.components.heater.minequippedheat = 0
    --     --inst.components.heater.maxequippedheat = TUNING.OBSIDIAN_TOOL_MAXHEAT
	--
    --     inst.components.heater.carriedheatfn = GetObsidianHeat
    --     inst.components.heater.mincarriedheat = 0
    --     inst.components.heater.maxcarriedheat = TUNING.OBSIDIAN_TOOL_MAXHEAT
    -- end

    -- if not inst.Light then
    --     --only add a light if there is no light already
    --     inst.entity:AddLight()
    --     inst.Light:SetFalloff(0.5)
    --     inst.Light:SetIntensity(0.75)
    --     inst.components.obsidiantool.onchargedelta = ChangeObsidianLight
    --     inst:ListenForEvent("equipped", ManageObsidianLight)
    --     inst:ListenForEvent("onputininventory", ManageObsidianLight)
    --     inst:ListenForEvent("ondropped", ManageObsidianLight)
    -- end

    -- if inst.components.weapon then
    --     if inst.components.weapon.onattack then
    --         print("Obsidian Weapon", inst, "already has an onattack!")
    --     else
    --         inst.components.weapon:SetOnAttack(ObsidianToolAttack)
    --     end
    -- end
end

local CHARS = {
	"GENERIC",
	"WILLOW",
	"WENDY",
	"WICKERBOTTOM",
	"WX78",
	"WATHGRITHR",
	"WEBBER",
	"WAXWELL",
	"WOODIE",
	"WINONA",
}

GLOBAL.jchmb.CopyPrefabDescriptions = function(oldprefab, newprefab)
	for i,character in ipairs(CHARS) do
		if GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE[string.upper(oldprefab)] ~= nil then
			GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE[string.upper(newprefab)] =
				GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE[string.upper(oldprefab)]
		end
	end
end

--[[
	Other functions
--]]
function AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, placer, numtogive)
	description = description or "???"
	atlas = atlas or "images/inventoryimages/" .. recipe .. ".xml"
	placer = placer or nil
	local newRecipe = Recipe(recipe, ingredients, tab, tech, placer)
	newRecipe.atlas = GLOBAL.resolvefilepath(atlas)
	if numtogive then
		newRecipe.numtogive = numtogive
	end
	GLOBAL.STRINGS.RECIPE_DESC[string.upper(recipe)] = description
	return newRecipe
end

function AddItemRecipe(recipe, ingredients, tab, tech, description, atlas, numtogive, nounlock)
	local newRecipe = AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, nil, numtogive)
	if nounlock then
		newRecipe.nounlock = true
	end
	return newRecipe
end

function AddStructureRecipe(recipe, ingredients, tab, tech, description, atlas, placer, nounlock)
	placer = placer or (recipe .. "_placer")
	local newRecipe = AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, placer)
	if nounlock then
		newRecipe.nounlock = true
	end
	return newRecipe
end

function AddLostRecipe(recipe, ingredients, tab, tech, description, atlas, placer)
	atlas = atlas or "images/inventoryimages/pighouse_gray.xml"
	return AddStructureRecipe(recipe, ingredients, tab, tech, description, atlas, placer)
end

function ModIngredient(prefab, count)
	return Ingredient(prefab, count, "images/inventoryimages/" .. prefab .. ".xml")
end

function AddTraderItem(prefab, cost, tab, tech, description, atlas, image, numtogive)
	local product
	if AllRecipes[prefab] then
		local lastid = TraderProducts[prefab] or 0
		local newid = lastid + 1
		TraderProducts[prefab] = newid
		product = "prefab_" .. tostring(newid)
	else
		product = prefab
	end
	local ingredients = {}
	if type(cost) ~= "table" then
		local currencyitem = "coin1"
		local ingredient
		if currencyitem == "goldnugget" then
			ingredient = Ingredient(currencyitem, cost)
		else
			ingredient = ModIngredient(currencyitem, cost)
		end
		ingredients =
		{
			ingredient,
		}
	else
		for k, v in pairs(cost) do
			local ing = ModIngredient(k, v)
			table.insert(ingredients, ing)
		end
	end


	local recipe = AddItemRecipe(product, ingredients, tab, tech, description, atlas, numtogive, true)
	recipe.product = prefab
	if image then
		recipe.image = image
	end
	return recipe
end

function AddMultiPrefabPostInit(prefabs, fn)
	for i,prefab in ipairs(prefabs) do
		AddPrefabPostInit(prefab, fn)
	end
end
