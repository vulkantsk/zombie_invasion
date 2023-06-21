LinkLuaModifier("modifier_lord_true_vampire_lord", "heroes/hero_lord/lord_true_vampire_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_true_vampire_lord = class({})

 function lord_true_vampire_lord:CastFilterResult()
        if not (self:GetCaster():HasModifier("modifier_lord_blood_rage")) then
            return UF_FAIL_CUSTOM
        end

        if self:GetCaster():HasModifier("modifier_lord_blood_rage") then
            local modif = self:GetCaster():FindModifierByName("modifier_lord_blood_rage")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return UF_FAIL_CUSTOM
            end
        end
        return UF_SUCCESS
end
  

function lord_true_vampire_lord:GetCustomCastError()
        if not (self:GetCaster():HasModifier("modifier_lord_blood_rage")) then
            return "#dota_hud_error_havent_charges"
        end

        if self:GetCaster():HasModifier("modifier_lord_blood_rage") then
            local modif = self:GetCaster():FindModifierByName("modifier_lord_blood_rage")
            if not (modif:GetStackCount() >= self:GetHealthCost(self:GetLevel())) then 
                return "#dota_hud_error_havent_charges"
            end
        end
        return UF_SUCCESS
end
 
function lord_true_vampire_lord:GetIntrinsicModifierName()
	return "modifier_lord_true_vampire_lord"
end


modifier_lord_true_vampire_lord = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        	MODIFIER_EVENT_ON_ATTACK,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        } end,
})

function modifier_lord_true_vampire_lord:OnCreated()
    self.attack_pct = self:GetAbility():GetSpecialValueFor("attack_pct")
    self.lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_resist = self:GetAbility():GetSpecialValueFor("bonus_resist")

    self.interval = self:GetAbility():GetSpecialValueFor("interval")

    self:StartIntervalThink(10)
        EmitSoundOn( "evolution", self:GetParent() )

    local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 

    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )

    InvasionMode:CreateDrop("item_alucard_weapon", self:GetParent():GetAbsOrigin() + RandomVector(RandomFloat(50, 200)) )

     
end 

function modifier_lord_true_vampire_lord:OnIntervalThink()
        local parent = self:GetParent()

        local modif = parent:FindModifierByName("modifier_lord_blood_rage")
        local max_charge =  modif:GetAbility():GetSpecialValueFor("max_blood") + self:GetAbility():GetSpecialValueFor("max_blood")

         local charges = self:GetAbility():GetSpecialValueFor("blood_per_tick") + modif:GetStackCount()
         
        modif:SetStackCount(math.min(charges,max_charge))

end 

 

function modifier_lord_true_vampire_lord:GetModifierPhysicalArmorBonus() 
    return self.bonus_armor
end

function modifier_lord_true_vampire_lord:GetModifierPreAttack_BonusDamage() 
    return self.bonus_damage
end

function modifier_lord_true_vampire_lord:GetModifierIncomingDamage_Percentage()
    return -self.bonus_resist
end

function modifier_lord_true_vampire_lord:OnAttack(keys)
    local parent = self:GetParent()
    local attacker = keys.attacker
    local target = keys.target
    if attacker == parent then 
        if RollPercentage(self.attack_pct) then 
          Timers:CreateTimer(0.5, function()  
            parent:PerformAttack(target, true, true, true, false, true, false, false)
         end)
      end
     end
end
 
function modifier_lord_true_vampire_lord:OnTakeDamage( keys )
    if  keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        -- Spell lifesteal handler
 
        if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
            -- Heal and fire the particle           
            self.lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
            ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
         
            keys.attacker:Heal(keys.damage * self.lifesteal_pct * 0.01, keys.attacker)
        end
    end
end


