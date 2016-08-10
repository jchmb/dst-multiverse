
-- Parameters:
-- inst: the entity that is WanderAndDoStuffing
-- homelocation: a position or a function that gets a position. If nil, the entity won't be leashed to their home
-- max_dist: maximum distance to go away from home (if there is a home) or a function returning such
-- times: see constructor. Note that the WanderAndDoStuff distance is hard-coded - if the walk time is too long, the entity will merely stand still after reaching their target point
-- getdirectionFn: instead of picking a random direction, try to use the one returned by this function
-- setdirectionFn: use this to store the direction that was randomly chosen
WanderAndDoStuff = Class(BehaviourNode, function(self, inst, homelocation, max_dist, times, setdirectionFn)
    BehaviourNode._ctor(self, "WanderAndDoStuff")
    self.homepos = homelocation
    self.maxdist = max_dist
    self.inst = inst
    self.far_from_home = false
    self.inst.stufftargetfn = inst.GetStuffTargetFn
    self.actionfn = inst.GetStuffActionFn

    self.getdirectionFn = function(inst)
        if inst.stufftarget == nil then
            return nil
        end
        return math.abs(inst:GetAngleToPoint(inst.stufftarget.Transform:GetWorldPosition()))
    end
    self.setdirectionFn = setdirectionFn
    
    self.times =
    {
		minwalktime = times and times.minwalktime or 2,
		randwalktime = times and times.randwalktime or 2,
		minwaittime = times and times.minwaittime or 1,
		randwaittime = times and times.randwaittime or 2,
    }
end)


function WanderAndDoStuff:Visit()
    if self.status == READY then
        self.inst.components.locomotor:Stop()
        self:Wait(self.times.minwaittime+math.random()*self.times.randwaittime)
        local targetfn1 = self.inst.stufftargetfn(self.inst)
        if targetfn1 ~= nil then
            self.inst.stufftarget = targetfn1(self.inst)
        end

        if targetfn1 ~= nil and self.inst.stufftarget ~= nil then
            self.status = RUNNING
            self.inst.components.locomotor:Stop()
            self:Wait(self.times.minwaittime+math.random()*self.times.randwaittime)
        else
            self.status = FAILED
        end
    end
    if self.inst.stufftarget ~= nil and self.status == RUNNING then
        local actionfn1 = self.actionfn(self.inst)
        if actionfn1(self.inst, self.inst.stufftarget) then
            self.status = SUCCESS
            self.inst.stufftarget = nil
        else
            if self.inst:GetDistanceSqToPoint(self.inst.stufftarget.Transform:GetWorldPosition()) <= 4 then
                self:Wait(self.times.minwaittime+math.random()*self.times.randwaittime)
                self.inst.components.locomotor:Stop()
            end
            if not self.walking and self:IsFarFromHome() then
                self:PickNewDirection()
            end
        
            if GetTime() > self.waittime then
                if not self.walking then
                    self:PickNewDirection()
                else
                    self:HoldPosition()
                end
            else
                if not self.walking then
                    self:Sleep(self.waittime - GetTime())
                else
                    if not self.inst.components.locomotor:WantsToMoveForward() then
                        self:HoldPosition()
                    end
                end
            end

        end
    end
    
    
end

local function tostring_float(f)
    return f and string.format("%2.2f", f) or tostring(f)
end

function WanderAndDoStuff:DBString()
    local w = self.waittime - GetTime()
    return string.format("%s for %2.2f, %s, %s, %s", 
        self.walking and 'walk' or 'wait', 
        w, 
        tostring(self:GetHomePos() or false), 
        tostring_float(math.sqrt(self:GetDistFromHomeSq() or 0)), 
        self.far_from_home and "Go Home" or "Go Wherever")
end

function WanderAndDoStuff:GetHomePos()
    if type(self.homepos) == "function" then 
        return self.homepos(self.inst)
    end
    
    return self.homepos
end

function WanderAndDoStuff:GetDistFromHomeSq()
    local homepos = self:GetHomePos()
	if not homepos then
		return nil
	end
    local pos = Vector3(self.inst.Transform:GetWorldPosition())
    return distsq(homepos, pos)
end
	
function WanderAndDoStuff:IsFarFromHome()
	if self:GetHomePos() then
		return self:GetDistFromHomeSq() > self:GetMaxDistSq()
	end
	return false
end


function WanderAndDoStuff:GetMaxDistSq()
    if type(self.maxdist) == "function" then
        local dist = self.maxdist(self.inst)
        return dist*dist
    end
    
    return self.maxdist*self.maxdist
end

function WanderAndDoStuff:Wait(t)
    self.waittime = t+GetTime()
    self:Sleep(t)
end

function WanderAndDoStuff:PickNewDirection()

    self.far_from_home = self:IsFarFromHome()

    self.walking = true
    
    if self.far_from_home then
        --print("Far from home, going back")
        --print(self.inst, Point(self.inst.Transform:GetWorldPosition()), "FAR FROM HOME", self:GetHomePos())
        self.inst.components.locomotor:GoToPoint(self:GetHomePos())
    else
        local pt = Point(self.inst.Transform:GetWorldPosition())
        local angle = (self.getdirectionFn and self.getdirectionFn(self.inst)) 
       -- print("got angle ", angle) 
        if not angle then 
            angle = math.random()*2*PI
            --print("no angle, picked", angle, self.setdirectionFn)
            if self.setdirectionFn then
                --print("set angle to ", angle) 
                self.setdirectionFn(self.inst, angle)
            end
        end

        local radius = 12
        local attempts = 8
        local offset, check_angle, deflected = FindWalkableOffset(pt, angle, radius, attempts, true, false) -- try to avoid walls
        if not check_angle then
            --print(self.inst, "no los WanderAndDoStuff, fallback to ignoring walls")
            offset, check_angle, deflected = FindWalkableOffset(pt, angle, radius, attempts, true, true) -- if we can't avoid walls, at least avoid water
        end
        if check_angle then
            angle = check_angle
            if self.setdirectionFn then
                --print("(second case) reset angle to ", angle) 
                self.setdirectionFn(self.inst, angle)
            end
        else
            -- guess we don't have a better direction, just go whereever
            --print(self.inst, "no walkdable WanderAndDoStuff, fall back to random")
        end
        --print(self.inst, pt, string.format("WanderAndDoStuff to %s @ %2.2f %s", tostring(offset), angle/DEGREES, deflected and "(deflected)" or ""))
        if offset then
            self.inst.components.locomotor:GoToPoint(self.inst:GetPosition() + offset)
        else
            self.inst.components.locomotor:WalkInDirection(angle/DEGREES)
        end
    end
    
    self:Wait(self.times.minwalktime+math.random()*self.times.randwalktime)
end

function WanderAndDoStuff:HoldPosition()
    self.walking = false
    self.inst.components.locomotor:Stop()
    self:Wait(self.times.minwaittime+math.random()*self.times.randwaittime)
end


