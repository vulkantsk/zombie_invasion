if item_milk_shake == nil then
	item_milk_shake = class({})
 
end


 

function item_milk_shake:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil

	if hTarget == hCaster then
		hCaster:EmitSound("drinking")
		hCaster:GiveMana(1000)
	else
		hTarget:EmitSound("drinking")
		hTarget:GiveMana(1000)
	end

	if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
		UTIL_Remove(hItem)
		return
	end

	hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end