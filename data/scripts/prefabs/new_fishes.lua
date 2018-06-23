local function _fn(data, common_init_fn, master_init_fn)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(data.build)
    inst.AnimState:SetBuild(data.build)

    inst:AddTag("meat")
    inst:AddTag("catfood")
    inst:AddTag("quagmire_stewable")

    if common_init_fn ~= nil then
        common_init_fn(inst)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- event_server_data("quagmire", "prefabs/quagmire_fish").master_postinit(inst)

    if master_init_fn ~= nil then
        master_init_fn(inst)
    end

    return inst
end

local function raw_fn(data)
    local function common_init(inst)
        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")

        if data.fish then
            inst.AnimState:PlayAnimation("idle", true)
            inst.data = {} -- because fishing stuff
        else
            inst.AnimState:PlayAnimation("idle")
        end
    end

    local function master_init(inst)
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_" .. data.name

        if data.caneatraw then
            inst:AddComponent("edible")
            inst.components.edible.healthvalue = data.health
            inst.components.edible.hungervalue = data.hunger
            inst.components.edible.sanityvalue = data.sanity or 0
            inst.components.edible.foodtype = FOODTYPE.FISH

            if data.oneatenfn ~= nil then
                inst.components.edible:SetOnEatenFn(data.oneatenfn)
            end
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(data.perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("cookable")
        inst.components.cookable.product = data.cooked

        inst:AddComponent("bait")
        inst:AddComponent("tradable")
        -- event_server_data("quagmire", "prefabs/quagmire_fish").master_postinit_raw(inst, data)
    end

    return function() return _fn(data, common_init, master_init) end
end

local function cooked_fn(data)
    local function common_init(inst)
        inst.AnimState:PlayAnimation("cooked")
    end

    local function master_init(inst)
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_" .. data.cooked

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.cooked_health
        inst.components.edible.hungervalue = data.cooked_hunger
        inst.components.edible.sanityvalue = data.cooked_sanity or 0
        inst.components.edible.foodtype = FOODTYPE.FISH

        if data.cooked_oneatenfn ~= nil then
            inst.components.edible:SetOnEatenFn(data.cooked_oneatenfn)
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(data.cooked_perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("bait")
        inst:AddComponent("tradable")
        -- event_server_data("quagmire", "prefabs/quagmire_fish").master_postinit_cooked(inst, data)
    end

    return function() return _fn(data, common_init, master_init) end
end

local prefab_list = {}
local function MakeMeatItem(data)
    table.insert(prefab_list, Prefab(data.name, raw_fn(data), data.assets, data.prefabs))
    table.insert(prefab_list, Prefab(data.cooked, cooked_fn(data), data.assets, data.prefabs))
end

MakeMeatItem({
    name = "salmon",
    cooked = "salmon_cooked",
    build = "quagmire_salmon",
    fish = true,
    assets =
    {
        Asset("ANIM", "anim/quagmire_salmon.zip"),
    },
    prefabs =
    {
        "salmon_cooked",
        "spoiled_food",
        -- "quagmire_burnt_ingredients",
    },
    caneatraw = true,
    health = 0,
    hunger = TUNING.CALORIES_SMALL,
    sanity = 0,
    perishtime = TUNING.PERISH_FAST,
    cooked_health = TUNING.HEALING_TINY,
    cooked_hunger = TUNING.CALORIES_SMALL,
    cooked_sanity = TUNING.SANITY_TINY,
    cooked_perishtime = TUNING.PERISH_FAST,
})

MakeMeatItem({
    name = "crabmeat",
    cooked = "crabmeat_cooked",
    build = "quagmire_crabmeat",
    assets =
    {
        Asset("ANIM", "anim/quagmire_crabmeat.zip"),
    },
    prefabs =
    {
        "crabmeat_cooked",
        "spoiled_food",
        -- "quagmire_burnt_ingredients",
    },
    perishtime = TUNING.PERISH_MED,
    cooked_health = TUNING.HEALING_TINY,
    cooked_hunger = TUNING.CALORIES_SMALL,
    cooked_sanity = TUNING.SANITY_TINY,
    cooked_perishtime = TUNING.PERISH_FAST,
    caneatraw = false,
})

return unpack(prefab_list)
