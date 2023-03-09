sf_scary_shape = class({})
sf_scary_shape_active = class({})
LinkLuaModifier( "modifier_sf_scary_shape", "heroes/hero_sf/sf_scary_shape/sf_scary_shape", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sf_scary_shape_active", "heroes/hero_sf/sf_scary_shape/sf_scary_shape", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sf_scary_shape_active_debuff", "heroes/hero_sf/sf_scary_shape/sf_scary_shape", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sf_necromastery_hero", "heroes/hero_sf/sf_necromastery_hero/sf_necromastery_hero", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function sf_scary_shape:GetIntrinsicModifierName()
	return "modifier_sf_scary_shape"
end

function sf_scary_shape_active:GetIntrinsicModifierName()
	return "modifier_sf_scary_shape_active"
end
 


modifier_sf_scary_shape = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
})
 

--------------------------------------------------------------------------------

function modifier_sf_scary_shape:OnCreated( kv )
self:StartIntervalThink( 0.2 )
end

function modifier_sf_scary_shape:OnIntervalThink()
	local caster = self:GetCaster()
	local modif = caster:FindModifierByName("modifier_sf_necromastery_hero")
    local ability_level = self:GetAbility():GetLevel()

	if modif:GetStackCount() >= 666 then 
		caster:AddAbility( "sf_scary_shape_active" ):SetLevel(ability_level)
		caster:SwapAbilities("sf_scary_shape", "sf_scary_shape_active", false, true)
     	caster:RemoveAbility("sf_scary_shape")
    end
end
 
modifier_sf_scary_shape_active = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
			MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,
})
 

--------------------------------------------------------------------------------

function modifier_sf_scary_shape_active:OnCreated( kv )
self:StartIntervalThink( 0.2 )
end

function modifier_sf_scary_shape_active:OnIntervalThink()
	local caster = self:GetCaster()
	local modif = caster:FindModifierByName("modifier_sf_necromastery_hero")
    local ability_level = self:GetAbility():GetLevel()
	if modif:GetStackCount() < 666 then 
		caster:AddAbility( "sf_scary_shape" ):SetLevel(ability_level)
		caster:SwapAbilities("sf_scary_shape_active", "sf_scary_shape", false, true)
     	caster:RemoveAbility("sf_scary_shape_active") 
    end
end
 

function modifier_sf_scary_shape_active:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local target_armor = target:GetPhysicalArmorValue(false)

        local modif = target:AddNewModifier(caster, ability, "modifier_sf_scary_shape_active_debuff", {duration = 0.01})
        modif.target_armor = target_armor
    end
end

modifier_sf_scary_shape_active_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_sf_scary_shape_active_debuff:OnCreated(data)
end


function modifier_sf_scary_shape_active_debuff:GetModifierPhysicalArmorBonus()
    return  -self.target_armor * (self:GetAbility():GetSpecialValueFor("reduced_armor")/100 )
end

 