if item_meat == nil then
	item_meat = class({})
 
end



 


function item_meat:CastFilterResultTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:IsRealHero() then
			return UF_FAIL_CUSTOM
		end

		if not hTarget:HasItemInInventory(self:GetAbilityName()) then
			if not hTarget:HasAnyAvailableInventorySpace() then
				return UF_FAIL_CUSTOM
			end
		end

		if self:GetCurrentCharges() < self:GetInitialCharges() then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
end


function item_meat:GetCustomCastErrorTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:IsRealHero() then
			return "#dota_hud_error_cheese_bad_target"
		end

		if not hTarget:HasItemInInventory(self:GetAbilityName()) then
			if not hTarget:HasAnyAvailableInventorySpace() then
				return "#dota_hud_error_full_inventory"
			end
		end

		if self:GetCurrentCharges() < self:GetInitialCharges() then
			return "#dota_hud_error_havent_charges"
		end

		return UF_SUCCESS
	end
end
 

function item_meat:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil
    local heal_meat = self:GetSpecialValueFor("heal")
	if hTarget == hCaster then
		hCaster:EmitSound("DOTA_Item.Cheese.Activate")
		hCaster:Heal(heal_meat,hCaster)
	else
		hTarget:EmitSound("DOTA_Item.Cheese.Activate")
		hTarget:Heal(heal_meat,hCaster)
	end

	if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
		UTIL_Remove(hItem)
		return
	end

	hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end