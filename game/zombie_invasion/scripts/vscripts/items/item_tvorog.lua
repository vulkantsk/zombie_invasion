 if item_tvorog == nil then
	item_tvorog = class({})
 
end

 

function item_tvorog:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil
		hCaster:EmitSound("eating")
		hCaster:RemoveItem(hItem)
    
 
end
    

