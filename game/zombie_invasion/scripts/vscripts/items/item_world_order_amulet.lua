LinkLuaModifier( "modifier_item_world_order_amulet", "items/item_world_order_amulet", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_world_order_amulet_aura", "items/item_world_order_amulet", LUA_MODIFIER_MOTION_NONE )

item_world_order_amulet = class({})

function item_world_order_amulet:GetIntrinsicModifierName() 
	return "modifier_item_world_order_amulet"
end

modifier_item_world_order_amulet = class({})

function modifier_item_world_order_amulet:IsHidden()
	return true
end

function modifier_item_world_order_amulet:IsPurgable()
    return false
end

function modifier_item_world_order_amulet:DeclareFunctions()
return 	{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		}
end


function modifier_item_world_order_amulet:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
	end
end

function modifier_item_world_order_amulet:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

function modifier_item_world_order_amulet:IsAura() return true end

function modifier_item_world_order_amulet:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_world_order_amulet:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_world_order_amulet:GetModifierAura()
    return "modifier_item_world_order_amulet_aura"
end


function modifier_item_world_order_amulet:GetAuraRadius()	
	return -1
end

modifier_item_world_order_amulet_aura = class({})


function modifier_item_world_order_amulet_aura:DeclareFunctions()
return 	{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
		}
end

function modifier_item_world_order_amulet_aura:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("armor_per_level") * self:GetAuraOwner():GetLevel()
	end
end

function modifier_item_world_order_amulet_aura:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("attack_speed_per_level") * self:GetAuraOwner():GetLevel()
	end
end

function modifier_item_world_order_amulet_aura:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_per_level") * self:GetAuraOwner():GetLevel()
	end
end

function modifier_item_world_order_amulet_aura:GetTexture()
    return "items/talisman"
end
