dragon_fear_aura = {}

LinkLuaModifier( "modifier_dragon_fear_aura", "heroes/hero_smaug/dragon_fear_aura/dragon_fear_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_fear_aura_debuff", "heroes/hero_smaug/dragon_fear_aura/dragon_fear_aura", LUA_MODIFIER_MOTION_NONE )

function dragon_fear_aura:GetIntrinsicModifierName()
    return "modifier_dragon_fear_aura"
end

modifier_dragon_fear_aura = {}

function modifier_dragon_fear_aura:IsHidden()
    return true
end

function modifier_dragon_fear_aura:IsPurgable()
    return false
end

function modifier_dragon_fear_aura:OnCreated()
    self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
end

function modifier_dragon_fear_aura:OnRefresh()
    self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
end

function modifier_dragon_fear_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end

function modifier_dragon_fear_aura:OnAttackStart( params )
    if IsServer() then
        if params.target~=self:GetParent() then return end
        if params.attacker:IsMagicImmune() then return end
        if self:GetParent():PassivesDisabled() then return end

        params.attacker:AddNewModifier(
            self:GetParent(),
            self:GetAbility(),
            "modifier_dragon_fear_aura_debuff",
            nil
        )
    end
end

function modifier_dragon_fear_aura:GetModifierSpellAmplify_Percentage()
    return self.spell_amp
end

modifier_dragon_fear_aura_debuff = {}

function modifier_dragon_fear_aura_debuff:IsHidden()
    return false
end

function modifier_dragon_fear_aura_debuff:IsDebuff()
    return true
end

function modifier_dragon_fear_aura_debuff:IsStunDebuff()
    return false
end

function modifier_dragon_fear_aura_debuff:IsPurgable()
    return true
end

function modifier_dragon_fear_aura_debuff:OnCreated( kv )
    self.outgoing = self:GetAbility():GetSpecialValueFor( "outgoing" )
    self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
    self.incoming = self:GetAbility():GetSpecialValueFor( "incoming" )
end

function modifier_dragon_fear_aura_debuff:OnRefresh( kv )
    self.outgoing = self:GetAbility():GetSpecialValueFor( "outgoing" )
    self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
    self.incoming = self:GetAbility():GetSpecialValueFor( "incoming" )
end

function modifier_dragon_fear_aura_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PRE_ATTACK,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,


    }
end

function modifier_dragon_fear_aura_debuff:GetModifierPreAttack( params )
    if IsServer() then
        
            self.record = params.record
            self.attackOther = true
    end
end

function modifier_dragon_fear_aura_debuff:OnAttack( params )
    if IsServer() then
        if params.record~=self.record then return end

        self:SetDuration(self.duration, true)
        self.HasAttacked = true
    end
end
function modifier_dragon_fear_aura_debuff:GetModifierDamageOutgoing_Percentage()
    return self.outgoing
end

function modifier_dragon_fear_aura_debuff:GetModifierMagicDamageOutgoing_Percentage()
    return self.outgoing
end
function modifier_dragon_fear_aura_debuff:GetModifierIncomingDamage_Percentage()
    return self.incoming
end
function modifier_dragon_fear_aura_debuff:GetEffectName()
    return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end
function modifier_dragon_fear_aura_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end