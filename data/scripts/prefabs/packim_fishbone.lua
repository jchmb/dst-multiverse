
local assets=
{
    Asset("ANIM", "anim/packim_fishbone.zip"),
    Asset("INV_IMAGE", "packim_fishbone_dead"),
   -- Asset("ANIM", "anim/chester_eyebone_build.zip"),

}

local SPAWN_DIST = 30

local trace = function() end

local function RebuildTile(inst)
    if inst.components.inventoryitem:IsHeld() then
        local owner = inst.components.inventoryitem.owner
        inst.components.inventoryitem:RemoveFromOwner(true)
        if owner.components.container then
            owner.components.container:GiveItem(inst)
        elseif owner.components.inventory then
            owner.components.inventory:GiveItem(inst)
        end
    end
end

local function GetSpawnPoint(pt)

    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

local function SpawnPackim(inst)

    local pt = Vector3(inst.Transform:GetWorldPosition())
    trace("    near", pt)

    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt then
        trace("    at", spawn_pt)
        local packim = SpawnPrefab("packim")
        if packim then
            packim.Physics:Teleport(spawn_pt:Get())
            packim:FacePoint(pt.x, pt.y, pt.z)

            return packim
        end

    else
        -- this is not fatal, they can try again in a new location by picking up the bone again
    end
end


local function StopRespawn(inst)
    if inst.respawntask then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindPackim(inst, packim)
    packim = packim or TheSim:FindFirstEntityWithTag("packim")
    if packim then
        -- inst.components.floatable:UpdateAnimations("idle_water", "idle_loop")
        -- if inst.components.floatable.onwater then
        --     inst.AnimState:PlayAnimation("idle_water")
        -- else
        inst.AnimState:PlayAnimation("idle_loop")
        -- end
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst:ListenForEvent("death", function() inst:OnPackimDeath() end, packim)

        if packim.components.follower.leader ~= inst then
            packim.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnPackim(inst)

    StopRespawn(inst)

    local packim = TheSim:FindFirstEntityWithTag("packim")
    if not packim then
        packim = SpawnPackim(inst)
    end
    RebindPackim(inst, packim)
end

local function StartRespawn(inst, time)
    StopRespawn(inst)

    local respawntime = time or 0
    if respawntime then
        inst.respawntask = inst:DoTaskInTime(respawntime, function() RespawnPackim(inst) end)
        inst.respawntime = GetTime() + respawntime
        -- inst.components.floatable:UpdateAnimations("dead_water", "dead")
        -- if inst.components.floatable.onwater then
        --     inst.AnimState:PlayAnimation("dead_water", true)
        -- else
        inst.AnimState:PlayAnimation("dead", true)
        -- end
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
    end
end

local function OnPackimDeath(inst)
    StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME)
end

local function FixPackim(inst)
	inst.fixtask = nil
	--take an existing chester if there is one
	if not RebindPackim(inst) then
        --inst.AnimState:PlayAnimation("dead", true)
        -- inst.components.floatable:UpdateAnimations("dead_water", "dead")
        -- if inst.components.floatable.onwater then
        --     inst.AnimState:PlayAnimation("dead_water", true)
        -- else
        inst.AnimState:PlayAnimation("dead", true)
        -- end
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)

		if inst.components.inventoryitem.owner then
			local time_remaining = 0
			local time = GetTime()
			if inst.respawntime and inst.respawntime > time then
				time_remaining = inst.respawntime - time
			end
			StartRespawn(inst, time_remaining)
		end
	end
end

local function OnPutInInventory(inst)
	if not inst.fixtask then
		inst.fixtask = inst:DoTaskInTime(1, function() FixPackim(inst) end)
	end
end

local function OnSave(inst, data)
    local time = GetTime()
    if inst.respawntime and inst.respawntime > time then
        data.respawntimeremaining = inst.respawntime - time
    end
end


local function OnLoad(inst, data)
    if data and data.respawntimeremaining then
		inst.respawntime = data.respawntimeremaining + GetTime()
	end
end

local function GetStatus(inst)
    if inst.respawntask then
        return "WAITING"
    end
end

--idle_water
--dead_water

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --so I can find the thing while testing
    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon( "treasure.png" )

    -- inst:AddTag("chester_eyebone") --This tag is used in save code and stuff, that's why I didn't change it
    inst:AddTag("packim_fishbone") -- This tag is used to check explicitly for packim_fishbone
    -- inst:AddTag("irreplaceable")
	-- inst:AddTag("nonpotatable")
    inst:AddTag("follower_leash")

    MakeInventoryPhysics(inst)
    -- MakeInventoryFloatable(inst, "idle_water", "idle_loop")

    inst.AnimState:SetBank("fishbone")
    inst.AnimState:SetBuild("packim_fishbone")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fishbone.xml"

    inst.openEye = "packim_fishbone"
    -- inst.closedEye = "packim_fishbone_dead"
    inst.closedEye = "packim_fishbone"

    inst.components.inventoryitem:ChangeImageName(inst.openEye)
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
	inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
    inst.OnPackimDeath = OnPackimDeath

	inst.fixtask = inst:DoTaskInTime(1, function() FixPackim(inst) end)

    return inst
end

return Prefab( "packim_fishbone", fn, assets)
