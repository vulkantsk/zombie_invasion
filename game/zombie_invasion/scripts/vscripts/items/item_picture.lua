
 

if item_picture == nil then
	item_picture = class({})
 
end


 


function item_picture:CastFilterResultTarget(hTarget)
	--print("Error")
	if IsServer() then
 
	if not  hTarget:IsBuilding()  then
 
       return UF_FAIL_CUSTOM
	end

		if self:GetCurrentCharges() < self:GetInitialCharges() then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
end


function item_picture:GetCustomCastErrorTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not  hTarget:IsBuilding() then
			return "#dota_hud_error_letter_bad_target"
		end
 

		if self:GetCurrentCharges() < self:GetInitialCharges() then
			return "#dota_hud_error_havent_charges"
		end     

		return UF_SUCCESS
	end
end

function item_picture:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
		local StackModifier = "modifier_item_letter"
	local itemName = self:GetAbilityName()
	local newItem = nil

	 

 	local currentStacks = hTarget:GetModifierStackCount(StackModifier, nil)

	if hTarget:GetUnitName() == "npc_main_elka"  and hTarget:IsBuilding() then
		if currentStacks == 0 then
			hTarget:AddNewModifier(hTarget, nil, StackModifier, {})
			hTarget:SetModifierStackCount(StackModifier, nil, (currentStacks + 1))
		else 
			hTarget:SetModifierStackCount(StackModifier, nil, (currentStacks + 1))
		end
 	if hItem:GetCurrentCharges() <= hItem:GetInitialCharges() then
		UTIL_Remove(hItem)
		return
	end

	hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
	end

 
end

 