local PoisonBlocker = Class(function(self, inst)
	self.inst = inst
	self.blockedfn = nil
end)

function PoisonBlocker:SetBlockedFn(fn)
	self.blockedfn = fn
end

function PoisonBlocker:IsBlocked(causer)
	if self.blockedfn then
		return self.blockedfn(self.inst, causer)
	else
		return false
	end
end

return PoisonBlocker