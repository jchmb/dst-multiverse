local assets =
{
    Asset("ANIM", "anim/coffeeham.zip"),
}

local prefabs =
{
    "spoiled_food",
}

local function MakePreparedFood(data)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        local anim = data.anim and data.anim or data.name
        local animfile = "anim/" .. anim .. ".zip"

        if data.dynamic then
            inst.AnimState:SetBank("quagmire_generic_plate")
            inst.AnimState:SetBuild("quagmire_generic_plate")
            inst.AnimState:PlayAnimation("idle")
            inst.AnimState:OverrideSymbol("swap_food", anim, "swap_food")
        else
            inst.AnimState:SetBank(anim)
            inst.AnimState:SetBuild(anim)
            inst.AnimState:PlayAnimation("idle", false)
        end

        if not data.ingredient then
            inst:AddTag("preparedfood")
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        if data.oneat then
            inst.components.edible:SetOnEatenFn(data.oneat)
        end

        inst:AddComponent("inspectable")
        inst.wet_prefix = data.wet_prefix

        inst:AddComponent("inventoryitem")
        if data.image then
            inst.components.inventoryitem.imagename = data.image .. ".tex"
        else
            inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. data.name .. ".xml"
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(data.perishtime or TUNING.PERISH_SLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        if data.tags then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)
        AddHauntableCustomReaction(inst, function(inst, haunter)
            --#HAUNTFIX
            --if math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE then
                --if inst.components.burnable and not inst.components.burnable:IsBurning() then
                    --inst.components.burnable:Ignite()
                    --inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
                    --inst.components.hauntable.cooldown_on_successful_haunt = false
                    --return true
                --end
            --end
            return false
        end, true, false, true)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        ------------------------------------------------

        return inst
    end

    local anim = data.anim and data.anim or data.name
    local my_assets = {}
    if data.dynamic then
        local dynamic = data.dynamic and "dynamic/" or ""
        local animfile = "anim/" .. dynamic .. anim .. ".zip"
        local animid = data.animid
        my_assets = {
            -- Asset("ANIM", animfile),
            Asset("ANIM", "anim/quagmire_generic_plate.zip"),
            Asset("ANIM", "anim/quagmire_generic_bowl.zip"),
            Asset("ATLAS", "images/quagmire_food_common_inv_images.xml"),
            Asset("IMAGE", "images/quagmire_food_common_inv_images.tex"),
            Asset("PKGREF", "klump/images/quagmire_food_inv_images_"..anim..".tex"),
            Asset("PKGREF", "klump/images/quagmire_food_inv_images_hires_"..anim..".tex"),
            Asset("PKGREF", "klump/anim/dynamic/"..anim..".dyn"),
            Asset("DYNAMIC_ATLAS", "images/quagmire_food_inv_images_"..anim..".xml"),
            Asset("DYNAMIC_ATLAS", "images/quagmire_food_inv_images_hires_"..anim..".xml"),
            Asset("DYNAMIC_ANIM", "anim/dynamic/"..anim..".zip"),
        }
    else
        my_assets = {
            Asset("ANIM", "anim/" .. anim .. ".zip"),
        }
    end

    return Prefab(data.name, fn, my_assets, prefabs)
end

local prefs = {}

local foods = require("newpreparedfoods")
for k,v in pairs(foods) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)
