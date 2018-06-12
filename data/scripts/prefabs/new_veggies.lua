require "tuning"

local function MakeVegStats(bank, seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity, oneatenfn)
    return {
        bank = bank,
        health = health,
        hunger = hunger,
        cooked_health = cooked_health,
        cooked_hunger = cooked_hunger,
        seed_weight = seedweight,
        perishtime = perish_time,
        cooked_perishtime = cooked_perish_time,
        sanity = sanity,
        cooked_sanity = cooked_sanity,
        oneatenfn = oneatenfn,
    }
end

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

local CAFFEINE_SPEED_MODIFIER = 1.4
local CAFFEINE_DURATION = 60

local function StartCaffeineFn(inst, eater)
    if inst.name == "coffeebeans_cooked" or inst.prefab == "coffeebeans_cooked" then
        if eater.components.locomotor ~= nil and eater.components.caffeinated ~= nil then
            eater.components.caffeinated:Caffeinate(CAFFEINE_SPEED_MODIFIER, CAFFEINE_DURATION)
        end
    end
end

local MOD_VEGGIES =
{
    coffeebeans = MakeVegStats(nil, 0,   TUNING.CALORIES_TINY,   0,  TUNING.PERISH_FAST, 0,
                                TUNING.CALORIES_TINY,   0,  TUNING.PERISH_SLOW * 2, -TUNING.SANITY_TINY, StartCaffeineFn),
    bittersweetberries = MakeVegStats("berries", 0,   TUNING.CALORIES_TINY,   -3,  TUNING.PERISH_FAST, -3,
                                 TUNING.CALORIES_TINY,   -3,  TUNING.PERISH_FAST, -3, nil),
    mintyberries = MakeVegStats("berries", 0,  5,   2,  TUNING.PERISH_FAST, 2,
                                 5,   3,  TUNING.PERISH_FAST, 2, nil),
    sweet_potato = MakeVegStats("sweet_potato",	COMMON, TUNING.CALORIES_SMALL,	TUNING.HEALING_TINY,	TUNING.PERISH_MED, 0,
                             	 TUNING.CALORIES_SMALL,	TUNING.HEALING_SMALL,	TUNING.PERISH_FAST, 0, nil),
    -- cacaobeans = MakeVegStats(0,   TUNING.CALORIES_TINY,   0,  TUNING.PERISH_FAST, 0,
    --                             TUNING.CALORIES_TINY,   3,  TUNING.PERISH_SLOW * 2, -TUNING.SANITY_TINY, nil),
}

local assets_seeds =
{
    Asset("ANIM", "anim/seeds.zip"),
}

local function MakeVeggie(name, has_seeds)

    local assets =
    {
        Asset("ANIM", "anim/berries.zip"),
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("ATLAS", "images/inventoryimages/" .. name .. ".xml"),
    }

    local assets_cooked =
    {
        Asset("ANIM", "anim/berries.zip"),
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("ATLAS", "images/inventoryimages/" .. name .. "_cooked.xml"),
    }

    local prefabs =
    {
        name.."_cooked",
        "spoiled_food",
    }

    if has_seeds then
        table.insert(prefabs, name.."_seeds")
    end

    local function fn_seeds()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("seeds")
        inst.AnimState:SetBuild("seeds")
        inst.AnimState:SetRayTestOnBB(true)

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.SEEDS

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst.AnimState:PlayAnimation("idle")
        inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"

        inst:AddComponent("bait")
        inst:AddComponent("plantable")
        inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
        inst.components.plantable.product = name

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        if MOD_VEGGIES[name].bank ~= nil then
            inst.AnimState:SetBank(MOD_VEGGIES[name].bank)
        else
            inst.AnimState:SetBank(name)
        end
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = MOD_VEGGIES[name].health
        inst.components.edible.hungervalue = MOD_VEGGIES[name].hunger
        inst.components.edible.sanityvalue = MOD_VEGGIES[name].sanity or 0
        inst.components.edible.foodtype = FOODTYPE.VEGGIE

        if MOD_VEGGIES[name].oneatenfn ~= nil then
            inst.components.edible:SetOnEatenFn(MOD_VEGGIES[name].oneatenfn)
        end

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(MOD_VEGGIES[name].perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        if name ~= "pumpkin" and
            name ~= "eggplant" and
            name ~= "durian" and
            name ~= "watermelon" then
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        end

        if name == "watermelon" then
            inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
            inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. name .. ".xml"

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        ------------------------------------------------

        inst:AddComponent("cookable")
        inst.components.cookable.product = name.."_cooked"

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    local function fn_cooked()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        if MOD_VEGGIES[name].bank ~= nil then
            inst.AnimState:SetBank(MOD_VEGGIES[name].bank)
        else
            inst.AnimState:SetBank(name)
        end
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("cooked")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(MOD_VEGGIES[name].cooked_perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = MOD_VEGGIES[name].cooked_health
        inst.components.edible.hungervalue = MOD_VEGGIES[name].cooked_hunger
        inst.components.edible.sanityvalue = MOD_VEGGIES[name].cooked_sanity or 0
        inst.components.edible.foodtype = FOODTYPE.VEGGIE
        if MOD_VEGGIES[name].oneatenfn ~= nil then
            inst.components.edible:SetOnEatenFn(MOD_VEGGIES[name].oneatenfn)
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. name .. "_cooked.xml"

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    local base = Prefab(name, fn, assets, prefabs)
    local cooked = Prefab(name.."_cooked", fn_cooked, assets_cooked)
    local seeds = has_seeds and Prefab(name.."_seeds", fn_seeds, assets_seeds) or nil

    return base, cooked, seeds
end

local prefs = {}
for veggiename,veggiedata in pairs(MOD_VEGGIES) do
    local veg, cooked, seeds = MakeVeggie(veggiename, veggiename ~= "mintyberries" and veggiename ~= "bittersweetberries" and veggiename ~= "berries" and veggiename ~= "cave_banana" and veggiename ~= "cactus_meat" and veggiename ~= "berries_juicy" and veggiename ~= "coffeebeans")
    table.insert(prefs, veg)
    table.insert(prefs, cooked)
    if seeds then
        table.insert(prefs, seeds)
    end
end

return unpack(prefs)
