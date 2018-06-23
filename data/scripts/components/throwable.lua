local Throwable = Class(function(self, inst)
	self.inst = inst
	self.onthrown = nil
	-- self.onland = nil
	self.throwdistance_controller = 10
	self.random_angle = 10

	self.yOffset = 1

	self.speed = 10
end)

function Throwable:GetThrowPoint()
	--For use with controller.
	local owner = self.inst.components.inventoryitem.owner
	if not owner then return end
	local pt = nil
	local rotation = owner.Transform:GetRotation()*DEGREES
	local pos = owner:GetPosition()

	for r = self.throwdistance_controller, 1, -1 do
        local numtries = 2*PI*r
		pt = FindValidPositionByFan(rotation, r, numtries, function() return true end) --TODO: #BDOIG Might not need to be walkable?
		if pt then
			return pt + pos
		end
	end
end

function Throwable:CanThrowAtPoint(pt)
	return true
end

function Throwable:CollectPointActions(doer, pos, actions, right)
    if right then
    	if self.target_position then
    		pos = self.target_position
    	end
		if self:CanThrowAtPoint(pos) then
			table.insert(actions, ACTIONS.THROW)
		end
	end
end

function Throwable:CollectEquippedActions(doer, target, actions, right)
	if right and self:CanThrowAtPoint(target:GetPosition()) then
		table.insert(actions, ACTIONS.THROW)
	end
end

function Throwable:Throw(pt, thrower)
	if not self:CanThrowAtPoint(pt) then
		return false
	end

	local tothrow = self.inst

	if thrower and self.inst.components.inventoryitem and self.inst.components.inventoryitem:IsHeldBy(thrower) then
		tothrow = thrower.components.inventory:DropItem(self.inst, false, nil, nil, false)
	end

	local grav = 36.66 --rough gravity value - I have no idea where this is actually set.
	local yOffset = self.yOffset
	local pos = self.inst:GetPosition()
	local offset = Vector3(0, yOffset, 0)
	local distance = pos:Dist(pt)
	local totarget = pt - pos
    local angle = math.atan2(totarget.z, totarget.x) + (math.random()*self.random_angle - (self.random_angle * 0.5))*DEGREES
    local time_to_target = distance/self.speed

    local Viy = ((grav*0.5*(time_to_target^2))+yOffset)/time_to_target

	tothrow.Transform:SetPosition((pos + offset):Get())
    tothrow.Physics:SetVel(self.speed*math.cos(angle), Viy, self.speed*math.sin(angle))

    local dir = Vector3((time_to_target*self.speed)*math.cos(angle), 0, (time_to_target*self.speed)*math.sin(angle))

    local thrownpt = thrower:GetPosition() + dir

	if self.onthrown then
		self.onthrown(tothrow, thrower, thrownpt, time_to_target)
	end

	tothrow:AddTag("falling")

	return true
end

return Throwable
