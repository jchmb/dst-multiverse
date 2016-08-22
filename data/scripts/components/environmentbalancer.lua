local EnvironmentBalancer = Class(function(self, inst)
	self.inst = inst
	self.balance = 0
	self.balanceThreshold = 3
	self.actionfn = nil
	self.balanceactionfn = nil
end)

function EnvironmentBalancer:GetAction()
	return function(inst)
		if self.actionfn ~= nil and self.balance <= self.balanceThreshold then
			return self.actionfn(self.inst)
		end
	end
end

function EnvironmentBalancer:GetBalanceAction()
	return function(inst)
		if self.balanceactionfn ~= nil and self.balance > 0 then
			return self.balanceactionfn(self.inst)
		end
	end
end

function EnvironmentBalancer:GetBehaviorTree()
	return PriorityNode(
		{
			DoAction(self.inst, self:GetAction()),
			DoAction(self.inst, self:GetBalanceAction())
		},
		0.25
	)
end

function EnvironmentBalancer:OnLoad(data)
	if data and data.balance then
		self.balance = data.balance
	end
end

function EnvironmentBalancer:OnSave()
	return {
		balance = self.balance,
	}
end

return EnvironmentBalancer