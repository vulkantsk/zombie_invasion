if item_milk == nil then
	item_milk = class({})
end

function item_milk:CastFilterResultTarget(hTarget)
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


function item_milk:GetCustomCastErrorTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:IsRealHero() then
			return "#dota_hud_error_milk_bad_target"
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

function item_milk:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local newItem = nil
    local mana = self:GetSpecialValueFor("mana")
	if hTarget == hCaster then
		hCaster:EmitSound("Item.MoonShard.Consume")
		hCaster:GiveMana(mana)
	else
		hTarget:EmitSound("Item.MoonShard.Consume")
		hTarget:GiveMana(mana)
	end

	if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
		UTIL_Remove(hItem)
		return
	end

	hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
end