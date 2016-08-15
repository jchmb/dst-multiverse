local EnvironmentBalancer = Class(function(self, inst)
	self.inst = inst
	self.balance = 0
	self.balanceThreshold = 3
	self.actionfn = nil
	self.balanceactionfn = nil
end)

function EnvironmentBalancer:GetAction()
	if self.actionfn ~= nil and self.balance <= self.balanceThreshold then
		return self.actionfn(self.inst)
	end
end

function EnvironmentBalancer:GetBalanceAction()
	if self.balanceactionfn ~= nil and self.balance > 0 then
		return self.balanceactionfn(self.inst)
	end
end

return EnvironmentBalancer