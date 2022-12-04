item_bloodstone_max = item_bloodstone_max or class({})
 
item_bloodstone_max_2 = item_bloodstone_max

LinkLuaModifier("modifier_bloodstone_max_lock", "items/magic/item_bloodstone_max", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_voodo_mask_passive", "items/magic/item_voodo_mask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodstone_max", "items/magic/item_bloodstone_max", LUA_MODIFIER_MOTION_NONE)
  
 
function item_bloodstone_max:GetIntrinsicModifierName()
	return "modifier_voodo_mask_passive"
end
  
 
function item_bloodstone_max:OnSpellStart()
 	local caster = self:GetCaster()
	local damage = caster:GetMaxHealth() * self:GetSpecialValueFor('damage')/100
	local duration = self:GetSpecialValueFor('buff_duration') 
	local duration_def = self:GetSpecialValueFor('debuff_duration') 

        caster:EmitSound("DOTA_Item.Bloodstone.Cast")

     

    if not caster:HasModifier("modifier_bloodstone_max_lock") then 
        caster:AddNewModifier(caster, self, "modifier_bloodstone_max", {duration = duration})
        caster:AddNewModifier(caster, self, "modifier_bloodstone_max_lock", {duration = duration_def})
    end
      
     
end

 


modifier_bloodstone_max = modifier_bloodstone_max or class({})

-- Modifier properties
function modifier_bloodstone_max:DeclareFunctions()
	return {
 
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_bloodstone_max:IsHidden()		return false end
function modifier_bloodstone_max:IsPurgable()		return false end
function modifier_bloodstone_max:RemoveOnDeath()	return true end


function modifier_bloodstone_max:OnCreated()
	self.interval = 0.25
    self:StartIntervalThink( self.interval )
    self.damage = 0
    local vood_modif = self:GetCaster():FindModifierByName("modifier_voodo_mask_passive")
    vood_modif.multiputi = self:GetAbility():GetSpecialValueFor('lifesteal_multiplier')    
end
 
function modifier_bloodstone_max:OnDestroy()

     local vood_modif = self:GetCaster():FindModifierByName("modifier_voodo_mask_passive")
     vood_modif.multiputi = nil
     self:GetCaster():GiveMana(self.damage * (  self:GetAbility():GetSpecialValueFor('mana_multiplier')/100) )
end

 function modifier_bloodstone_max:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
 
			
			-- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
			-- This is EXTREMELY rough because I am not aware of any functions that can explicitly give you the incoming/outgoing damage of an illusion, or to give you the "displayed" damage when you're hitting illusions, which show numbers as if you were hitting a non-illusion.
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
				elseif keys.damage_type == DAMAGE_TYPE_PURE then
					keys.damage = keys.original_damage
				end
			end
			
			if keys.unit:IsCreep() then
                self.damage = self.damage + keys.damage 
               else
               self.damage = self.damage + keys.damage 
			end
		end
	end
end 

function modifier_bloodstone_max:GetEffectName()
    if self:GetAbility():GetName() == "item_bloodstone_max"  then
 		return "particles/items_fx/bloodstone_heal.vpcf"
    else
	    return "particles/items/bloodstone_heal.vpcf"
    end
end 

function modifier_bloodstone_max:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end 
 

modifier_bloodstone_max_lock = {}
 
function modifier_bloodstone_max_lock:IsHidden()		return false end
function modifier_bloodstone_max_lock:IsPurgable()		return false end
function modifier_bloodstone_max_lock:RemoveOnDeath()	return false end