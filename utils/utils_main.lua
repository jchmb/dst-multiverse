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
function AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, placer)
	description = description or "???"
	atlas = atlas or "images/inventoryimages/pighouse_gray.xml"
	placer = placer or nil
	local newRecipe = Recipe(recipe, ingredients, tab, tech, placer)
	newRecipe.atlas = GLOBAL.resolvefilepath(atlas)
	GLOBAL.STRINGS.RECIPE_DESC[string.upper(recipe)] = description
end

function AddItemRecipe(recipe, ingredients, tab, tech, description, atlas)
	AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, nil)
end

function AddStructureRecipe(recipe, ingredients, tab, tech, description, atlas, placer)
	placer = placer or (recipe .. "_placer")
	AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, placer)
end