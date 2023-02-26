

item_mask_of_madness_2 = class({})
item_mask_of_madness_3 = class({})
LinkLuaModifier("modifier_item_mask_of_madness_custom", "items/carry/item_mask_of_madness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mask_of_madness_berserk_up", "items/carry/item_mask_of_madness", LUA_MODIFIER_MOTION_NONE)
 LinkLuaModifier("modifier_lifesteal", "modifiers/modifier_lifesteal", LUA_MODIFIER_MOTION_NONE)

item_mask_of_madness_2 = class({
    GetIntrinsicModifierName = function()
        return "modifier_item_mask_of_madness_custom"
    end
})


function item_mask_of_madness_2:OnSpellStart()
	-- Play cast sound
	EmitSoundOn("DOTA_Item.MaskOfMadness.Activate", self:GetCaster())

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_mask_of_madness_berserk_up", {duration = self:GetSpecialValueFor("berserk_duration")})
end

function item_mask_of_madness_3:GetIntrinsicModifierName()
	return "modifier_item_mask_of_madness_custom"
end

function item_mask_of_madness_3:OnSpellStart()
	-- Play cast sound
	EmitSoundOn("DOTA_Item.MaskOfMadness.Activate", self:GetCaster())

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_mask_of_madness_berserk_up", {duration = self:GetSpecialValueFor("berserk_duration")})
end


-- Passive MoM modifier
modifier_item_mask_of_madness_custom = class({
    IsHidden = function()
        return true
    end,
    IsPurgable = function()
        return false
    end,
    IsPurgeException = function()
        return false
    end,	
    RemoveOnDeath = function()
        return false
    end,
	IsDebuff = function()
		return false
	end,
    DeclareFunctions = function()
        return {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
             
        }
    end,
 
	GetAttributes = function()
		return MODIFIER_ATTRIBUTE_MULTIPLE
	end,
})
 

function modifier_item_mask_of_madness_custom:OnCreated()	
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
     self.bonus_damage     = self.ability:GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed     = self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.modif_lif = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_lifesteal", {})
 
    
 
end

function modifier_item_mask_of_madness_custom:OnRefresh()
	self.ability = self:GetAbility()

    self.bonus_damage  = self.ability:GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed   = self.ability:GetSpecialValueFor("bonus_attack_speed")
 
end

function modifier_item_mask_of_madness_custom:GetModifierPreAttack_BonusDamage()
	return    self.bonus_damage
end

function modifier_item_mask_of_madness_custom:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mask_of_madness_custom:OnDestroy()
	    self.parent = self:GetParent()
	    self.modif_lif:Destroy()
	 
end
 
-- Berserk modifier
modifier_item_mask_of_madness_berserk_up = class({})

function modifier_item_mask_of_madness_berserk_up:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
 
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
 
	-- Ability specials
	self.berserk_attack_speed = self.ability:GetSpecialValueFor("berserk_bonus_attack_speed")
	self.berserk_ms_bonus_pct = self.ability:GetSpecialValueFor("berserk_bonus_movement_speed")
	self.berserk_armor_reduction = self.ability:GetSpecialValueFor("berserk_armor_reduction")
	self.berserk_base_damage = self.ability:GetSpecialValueFor("berserk_base_damage") 
end
 

function modifier_item_mask_of_madness_berserk_up:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

function modifier_item_mask_of_madness_berserk_up:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_mask_of_madness_berserk_up:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}

	return decFunc
end

function modifier_item_mask_of_madness_berserk_up:GetModifierBaseDamageOutgoing_Percentage()
	return self.berserk_base_damage
end

function modifier_item_mask_of_madness_berserk_up:GetModifierMoveSpeedBonus_Percentage()
	return self.berserk_ms_bonus_pct
end

function modifier_item_mask_of_madness_berserk_up:GetModifierAttackSpeedBonus_Constant()
	return self.berserk_attack_speed
end

function modifier_item_mask_of_madness_berserk_up:GetModifierPhysicalArmorBonus()
	return self.berserk_armor_reduction * (-1)
end

function modifier_item_mask_of_madness_berserk_up:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state
end
 

function modifier_item_mask_of_madness_berserk_up:OnDestroy()
	if IsServer() then
 
	end
end

function modifier_item_mask_of_madness_berserk_up:IsHidden()
	return false
end

function modifier_item_mask_of_madness_berserk_up:IsPurgable()
	return false
end

function modifier_item_mask_of_madness_berserk_up:IsDebuff()
	return false
end
 
 