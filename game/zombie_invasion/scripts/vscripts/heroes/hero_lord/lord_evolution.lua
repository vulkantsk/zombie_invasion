LinkLuaModifier("modifier_lord_evolution", "heroes/hero_lord/lord_evolution", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_evolution = class({})

 function lord_evolution:CastFilterResult()
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
  

function lord_evolution:GetCustomCastError()
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
 
function lord_evolution:GetBehavior()
    if self:GetLevel() < 5 or  (self:GetCaster():HasShard()) then 
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    else 
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
end

function lord_evolution:GetIntrinsicModifierName()
	return "modifier_lord_evolution"
end

function lord_evolution:OnSpellStart()
    local caster = self:GetCaster()
    local healthCost = self:GetHealthCost(self:GetLevel())

    local modif = caster:FindModifierByName("modifier_lord_blood_rage")
    modif:SetStackCount(modif:GetStackCount() - healthCost)    
    if self:GetCaster():HasShard() then 
        caster:AddAbility( "lord_true_lord" ):SetLevel(1)
        caster:SwapAbilities( "lord_evolution", "lord_true_lord", false, true )
    else
      self:SetLevel(self:GetLevel() + 1)
    end
end


modifier_lord_evolution = class({
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

function modifier_lord_evolution:OnCreated()
    self.levelAbility = self:GetAbility():GetLevel()

    self.attack_pct = self:GetAbility():GetSpecialValueFor("attack_pct")
    self.lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_resist = self:GetAbility():GetSpecialValueFor("bonus_resist")

    local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        EmitSoundOn( "evolution", self:GetParent() )


    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )

     
end 

function modifier_lord_evolution:OnRefresh()
    self:OnCreated()
end 

function modifier_lord_evolution:GetModifierPhysicalArmorBonus() 
    if self.levelAbility < 3 then return end 

    return self.bonus_armor
end

function modifier_lord_evolution:GetModifierPreAttack_BonusDamage() 
    if self.levelAbility < 4 then return end 

    return self.bonus_damage
end

function modifier_lord_evolution:GetModifierIncomingDamage_Percentage()
    if self.levelAbility < 5 then return end 

    return -self.bonus_resist
end

function modifier_lord_evolution:OnAttack(keys)
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
 
function modifier_lord_evolution:OnTakeDamage( keys )
    if self.levelAbility < 2 then return end 
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


