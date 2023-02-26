LinkLuaModifier("modifier_item_vampire_claw", "items/carry/item_vampire_claw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lifesteal", "modifiers/modifier_lifesteal", LUA_MODIFIER_MOTION_NONE)


item_vampire_claw = class({
    GetIntrinsicModifierName = function()
        return "modifier_item_vampire_claw"
    end
})

function item_vampire_claw:Precache(context)
	PrecacheResource("particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", context)
end

function item_vampire_claw:GetAbilityTextureName()
    local charges = self:GetCurrentCharges()
    if charges < 5 then
        return "carry/vampire_claw_1"
    elseif charges < 10 then
        return "carry/vampire_claw_2"
    elseif charges < 15 then
        return "carry/vampire_claw_3"
    else
        return "carry/vampire_claw_4"
    end
end

function item_vampire_claw:OnSpellStart()
    local charges = self:GetCurrentCharges()
    if charges <= 0 then 
        return 
    end
    local caster = self:GetCaster()
    local healing = charges * self:GetSpecialValueFor("heal_per_charge")
    caster:Heal(healing, self)
    self:SetCurrentCharges(0)

    SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, healing, nil)

    local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "", caster:GetAbsOrigin(), true)
 
    EmitSoundOn("hero_bloodseeker.bloodRite.silence", caster)
end

modifier_item_vampire_claw = class({
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
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_EVENT_ON_ATTACK_LANDED,
             
        }
    end,
 
    GetModifierBonusStats_Strength = function(self)
        return self.bonusStr
    end,
	GetAttributes = function()
		return MODIFIER_ATTRIBUTE_MULTIPLE
	end
})

function modifier_item_vampire_claw:OnCreated()
	self.parent = self:GetParent()
    self.modif_lif = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_lifesteal", {})
 self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self:OnRefresh()
end

function modifier_item_vampire_claw:OnRefresh()
	self.ability = self:GetAbility()
    if(not self.ability or self.ability:IsNull()) then
        return
    end
    self.bonusStr     = self.ability:GetSpecialValueFor("bonus_str")
    self.bonusDamage = self.ability:GetSpecialValueFor("bonus_damage")
    self.lifesteal    = self.ability:GetSpecialValueFor("lifesteal")
    self.chargesPerBossAttack    = self.ability:GetSpecialValueFor("charges_for_attack_boss")
    self.chargesPerCreepAttack    = self.ability:GetSpecialValueFor("charges_for_attack_creep")
    self.maxCharges    = self.ability:GetSpecialValueFor("max_charges")
end

function modifier_item_vampire_claw:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
end


function modifier_item_vampire_claw:OnDestroy()
    self.parent = self:GetParent()
            self.modif_lif:Destroy()
end

function modifier_item_vampire_claw:OnAttackLanded(kv)
    if(kv.attacker ~= self.parent) then
        return
    end
     
    local currentCharges = self.ability:GetCurrentCharges()

    local bonusChargesPerAttack = self.chargesPerCreepAttack
 

    self.ability:SetCurrentCharges(math.min(currentCharges + bonusChargesPerAttack, self.maxCharges))
end

 