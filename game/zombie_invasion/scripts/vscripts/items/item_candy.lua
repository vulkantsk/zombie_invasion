
LinkLuaModifier("modifier_item_candy", "items/item_candy", LUA_MODIFIER_MOTION_NONE)


if item_candy == nil then
	item_candy = class({})
 
end



 


function item_candy:CastFilterResultTarget(hTarget)
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


function item_candy:GetCustomCastErrorTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not  hTarget:IsBuilding() then
			return "#dota_hud_error_candy_bad_target"
		end
 

		if self:GetCurrentCharges() < self:GetInitialCharges() then
			return "#dota_hud_error_havent_charges"
		end     

		return UF_SUCCESS
	end
end

function item_candy:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
		local StackModifier = "modifier_item_candy"
	local itemName = self:GetAbilityName()
	local newItem = nil

	 	      EmitSoundOn("DOTA_Item.Refresher.Activate", hTarget) 

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

modifier_item_candy = modifier_item_candy or class({})
function modifier_item_candy:IsDebuff() return false end
function modifier_item_candy:IsBuff() return true end
function modifier_item_candy:IsHidden() return false end
function modifier_item_candy:IsPurgable() return false end
function modifier_item_candy:IsStunDebuff() return false end
function modifier_item_candy:RemoveOnDeath() return false end
-------------------------------------------
function modifier_item_candy:GetTexture() 
return "item_halloween_candy" 
end


function modifier_item_candy:DeclareFunctions()
	local decFuns =
		{
		 
		}
	return decFuns
end
 

function modifier_item_candy:OnCreated()
 
end

 function modifier_item_candy:OnIntervalThink()
  


 --print(prosto_elka)
end
