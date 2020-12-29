
LinkLuaModifier("modifier_item_letter", "items/item_letter", LUA_MODIFIER_MOTION_NONE)


if item_letter == nil then
	item_letter = class({})
 
end



 


function item_letter:CastFilterResultTarget(hTarget)
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


function item_letter:GetCustomCastErrorTarget(hTarget)
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

function item_letter:OnSpellStart()
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
		hCaster:RemoveItem(hItem)
		return
	end

	hItem:SetCurrentCharges(hItem:GetCurrentCharges() - hItem:GetInitialCharges())
	end

 
end

modifier_item_letter = modifier_item_letter or class({})
function modifier_item_letter:IsDebuff() return false end
function modifier_item_letter:IsBuff() return true end
function modifier_item_letter:IsHidden() return false end
function modifier_item_letter:IsPurgable() return false end
function modifier_item_letter:IsStunDebuff() return false end
function modifier_item_letter:RemoveOnDeath() return false end
-------------------------------------------
function modifier_item_letter:GetTexture() 
return "item_letter" 
end


function modifier_item_letter:DeclareFunctions()
	local decFuns =
		{
		 
		}
	return decFuns
end
 

function modifier_item_letter:OnCreated()
 
end

 function modifier_item_letter:OnIntervalThink()
  


 --print(prosto_elka)
end
