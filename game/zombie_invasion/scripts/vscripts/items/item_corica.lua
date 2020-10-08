if item_corica == nil then
	item_corica = class({})
 
 
end

 

function item_corica:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
 
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil
 
	if hCaster == hCaster then
		hCaster:EmitSound("DOTA_Item.Cheese.Activate")
		hCaster:Heal(1000,hCaster)
	else
		hCaster:EmitSound("DOTA_Item.Cheese.Activate")
		hCaster:Heal(1000,hCaster)
	end

	if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
		hCaster:RemoveItem(hItem)
		return
	end

	hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end