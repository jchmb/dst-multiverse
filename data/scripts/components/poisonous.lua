local Poisonous = Class(function(self, inst)
	self.inst = inst
	self.poisontestfn = function(x, target)
		return math.random() < 0.5
	end
	self.dmg = nil
	self.interval = nil
	self.duration = nil
end)

function Poisonous:OnAttack(target, dmg)
	if target and target.components.poisonable and self.poisontestfn and self.poisontestfn(self.inst, target) then
		target.components.poisonable:SetPoison(self.dmg, self.interval, self.duration)
	end
end

function Poisonous:SetPoisonTestFn(fn)
	self.poisontestfn = fn
end

return Poisonous