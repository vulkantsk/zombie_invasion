 
if item_legendery_tom == nil then
	item_legendery_tom = class({})
 
end



 




function item_legendery_tom:CastFilterResultTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:HasAbility("hommer_cry") then
			return UF_FAIL_CUSTOM
		end

 
 

		return UF_SUCCESS
	end
end


function item_legendery_tom:GetCustomCastErrorTarget(hTarget)
	--print("Error")
	if IsServer() then
		if not hTarget:HasAbility("hommer_cry") then
			return "#dota_hud_error_cheese_bad_target"
		end

 
 

		return UF_SUCCESS
	end
end
 

function item_legendery_tom:OnSpellStart()
	--print("OnSpellStart")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hItem = self
	local itemName = self:GetAbilityName()
	local Ability_exist = {"homer_vampiric_aura"}

if hTarget:GetUnitName() == "NPC_base" then 
 
        hTarget:AddAbility(Ability_exist[RandomInt(1, #Ability_exist)]):SetLevel(1)
		hTarget:EmitSound("General.LevelUp.Bonus")
		hCaster:RemoveItem(hItem)
 else 
 	return nil
 end
 
end
 