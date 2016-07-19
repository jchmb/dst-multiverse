local function ondeploy(inst, pt, deployer)
    if deployer and deployer.SoundEmitter then
        deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
    end

    local map = TheWorld.Map
    local original_tile_type = map:GetTileAtPoint(pt:Get())
    local x, y = map:GetTileCoordsAtPoint(pt:Get())
    if x and y then
        map:SetTile(x,y, inst.data.tile)
        map:RebuildLayer( original_tile_type, x, y )
        map:RebuildLayer( inst.data.tile, x, y )
    end

    local minimap = TheWorld.minimap.MiniMap
    minimap:RebuildLayer(original_tile_type, x, y)
    minimap:RebuildLayer(inst.data.tile, x, y)

    inst.components.stackable:Get():Remove()
end

local assets =
{
    Asset("ANIM", "anim/turf.zip"),
    Asset("ANIM", "anim/grass.zip"),
}

local prefabs =
{
    "gridplacer",
}

local function make_turf(data)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("groundtile")

        inst.AnimState:SetBank("turf")
        inst.AnimState:SetBuild("turf")
        inst.AnimState:PlayAnimation(data.anim)

        inst:AddTag("molebait")
        --MakeDragonflyBait(inst, 3)

        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryitems/turf_" .. data.name .. ".xml"
        inst.data = data

        inst:AddComponent("bait")
        
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
        MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable.ondeploy = ondeploy
        if data.tile == "webbing" then
            inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        else
            inst.components.deployable:SetDeployMode(DEPLOYMODE.TURF)
        end
        inst.components.deployable:SetUseGridPlacer(true)

        ---------------------
        return inst
    end

    return Prefab("turf_"..data.name, fn, assets, prefabs)
end

local turfs =
{
    {name="snowy",          anim="grass",       tile=GROUND.SNOWY},
    {name="slimey",         anim="grass",      tile=GROUND.SLIMEY},
}

for k,v in pairs(turfs) do
    table.insert(assets, Asset("ATLAS", "images/inventoryimages/turf_" .. v.name .. ".xml"))
    table.insert(assets, Asset("IMAGE", "images/inventoryimages/turf_" .. v.name .. ".tex"))
end

local prefabs= {}
for k,v in pairs(turfs) do
    table.insert(prefabs, make_turf(v))
end

return unpack(prefabs)