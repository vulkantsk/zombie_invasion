zombie_armor_decress = class({})
zombie_armor_decress_2 = class({})
zombie_armor_decress_3 = class({})
 
LinkLuaModifier( "modifier_zombie_armor_decress", "abilities/monsters/wave_abilities/zombie_armor_decress", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_armor_decress_debuff", "abilities/monsters/wave_abilities/zombie_armor_decress", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function zombie_armor_decress:GetIntrinsicModifierName()
	return "modifier_zombie_armor_decress"
end

 
modifier_zombie_armor_decress = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_armor_decress:IsHidden()
	return true
end

function modifier_zombie_armor_decress:IsPurgable()
	return false
end


 modifier_zombie_armor_decress = class({
   IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_zombie_armor_decress:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("corruption_duration")

        target:AddNewModifier(caster, ability, "modifier_zombie_armor_decress_debuff", {duration = duration})
    end
end

 modifier_zombie_armor_decress_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_zombie_armor_decress_debuff:OnCreated(data)
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("armor_debuff")
end


function modifier_zombie_armor_decress_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_debuff
end

LinkLuaModifier( "modifier_zombie_armor_decress_2", "abilities/monsters/wave_abilities/zombie_armor_decress", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_armor_decress_2_debuff", "abilities/monsters/wave_abilities/zombie_armor_decress", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function zombie_armor_decress_2:GetIntrinsicModifierName()
    return "modifier_zombie_armor_decress_2"
end

 
modifier_zombie_armor_decress_2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_armor_decress_2:IsHidden()
    return true
end

function modifier_zombie_armor_decress_2:IsPurgable()
    return false
end


 modifier_zombie_armor_decress_2 = class({
   IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_zombie_armor_decress_2:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("corruption_duration")

        target:AddNewModifier(caster, ability, "modifier_zombie_armor_decress_debuff", {duration = duration})
    end
end

 modifier_zombie_armor_decress_2_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_zombie_armor_decress_2_debuff:OnCreated(data)
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("armor_debuff")
end


function modifier_zombie_armor_decress_2_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_debuff
end


LinkLuaModifier( "modifier_zombie_armor_decress_3", "abilities/monsters/wave_abilities/zombie_armor_decress", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_armor_decress_3_debuff", "abilities/monsters/wave_abilities/zombie_armor_decress", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function zombie_armor_decress_3:GetIntrinsicModifierName()
    return "modifier_zombie_armor_decress_3"
end

 
modifier_zombie_armor_decress_3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_armor_decress_3:IsHidden()
    return true
end

function modifier_zombie_armor_decress_3:IsPurgable()
    return false
end


 modifier_zombie_armor_decress_3 = class({
   IsHidden        = function(self) return true end,
    GetAttributes   = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions  = function(self) return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }end,
})


function modifier_zombie_armor_decress_3:OnAttackLanded(data)
    local caster = self:GetCaster()
    local target = data.target
    local attacker = data.attacker

    if attacker == caster then
        local ability = self:GetAbility()
        local duration = ability:GetSpecialValueFor("corruption_duration")

        target:AddNewModifier(caster, ability, "modifier_zombie_armor_decress_debuff", {duration = duration})
    end
end

 modifier_zombie_armor_decress_3_debuff = class({
    IsHidden        = function(self) return false end,
    DeclareFunctions  = function(self) return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

    }end,
})


function modifier_zombie_armor_decress_3_debuff:OnCreated(data)
    local ability = self:GetAbility()
    self.armor_debuff = ability:GetSpecialValueFor("armor_debuff")
end


function modifier_zombie_armor_decress_3_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_debuff
end

