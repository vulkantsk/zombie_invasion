LinkLuaModifier("modifier_bone", "items/item_bone.lua", LUA_MODIFIER_MOTION_NONE)


function SetStacks( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local stacks = ability:GetSpecialValueFor( "stacks" )
	local StackModifier = "modifier_bone"
 

	local currentStacks = target:GetModifierStackCount(StackModifier, ability)
 
	if currentStacks == 0 then
		target:AddNewModifier(caster, ability, StackModifier, {})
		target:SetModifierStackCount(StackModifier, ability, (currentStacks + stacks))
        target:CalculateStatBonus(true)		
	else 
		target:SetModifierStackCount(StackModifier, ability, (currentStacks + stacks))
        target:CalculateStatBonus(true)		
	end
 
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

 
-------------------------------------------
modifier_bone = modifier_bone or class({})
function modifier_bone:IsDebuff() return false end
function modifier_bone:IsBuff() return true end
function modifier_bone:IsHidden() return false end
function modifier_bone:IsPurgable() return false end
function modifier_bone:IsStunDebuff() return false end
function modifier_bone:RemoveOnDeath() return false end
-------------------------------------------
 
function modifier_bone:OnCreated( kv )
	-- references
  self.bonus_hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
  self.bonus_regen =  self:GetAbility():GetSpecialValueFor("bonus_regen")
 
   
end
 
 function modifier_bone:GetTexture()
	-- references
return  "item_bones" 
   
end
 


function modifier_bone:DeclareFunctions()
	local decFuns =
		{
	 	     MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT ,
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
		}
	return decFuns
end

function modifier_bone:GetModifierConstantHealthRegen()
	return self:GetStackCount() * self.bonus_regen
end

--function modifier_bone:GetModifierPhysicalArmorBonus()
--	return self:GetStackCount()*0.5
--end

function modifier_bone:GetModifierExtraHealthBonus()
	return self:GetStackCount() * self.bonus_hp
end


