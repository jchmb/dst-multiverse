local Taxed = Class(function(self, inst)
	self.inst = inst
	self.paymentTypeFn = nil
	self.taxRate = 60 * 8		-- One every day
	self.timeLeft = nil
	self.dueThreshold = 3
	self.due = {}
end)

function Taxed:SetPaymentTypeFn(fn)
	self.paymentTypeFn = fn
end

function Taxed:SetTaxRate(taxRate)
	self.taxRate = taxRate
end

function Taxed:ReservePlayer(player)
	if not player.userid then
		self.due[player.userid] = 0
		self.records[player.userid] = 0
	end
end

function Taxed:DoDelta(player, amount)
	self:ReservePlayer(player)
	self.due[player.userid] = self.due[player.userid] + amount
end

function Taxed:DoPayment(player, amount)
	amount = amount or 1
	self:DoDelta(player, -amount)
end

function Taxed:Taxate()
	for i,player in ipairs(AllPlayers) do
		self:DoDelta(player, 1)
	end
end

function Taxed:OnSave()
	return {
		timeLeft = self.timeLeft,
		due = self.due,
	}
end

function Taxed:OnLoad(data)
	if data.timeLeft then
		self.timeLeft = data.timeLeft
	end
	if data.due then
		self.due = data.due
	end
end

function Taxed:IsValidPayment(item)
	return paymentTypeFn(item)
end

function Taxed:IsTaxAvoider(player)
	return player.userid and self.due[player.userid] and self.due[player.userid] >= self.dueThreshold
end

function Taxed:OnUpdate(dt)
	self.timeLeft = self.timeLeft - dt
	if self.timeLeft <= 0 then
		self:Taxate()
		self.timeLeft = self.taxRate
	end
end

return Taxed