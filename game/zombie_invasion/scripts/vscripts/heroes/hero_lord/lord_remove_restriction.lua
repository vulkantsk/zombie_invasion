LinkLuaModifier("modifier_lord_remove_restriction", "heroes/hero_lord/lord_remove_restriction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_remove_restriction_before", "heroes/hero_lord/lord_remove_restriction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lord_blood_rage", "heroes/hero_lord/lord_blood_rage", LUA_MODIFIER_MOTION_NONE)


lord_remove_restriction = class({})

 function lord_remove_restriction:CastFilterResult()
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
  

function lord_remove_restriction:GetCustomCastError()
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
  
 
function lord_remove_restriction:OnSpellStart()
    local caster = self:GetCaster()
    local healthCost = self:GetHealthCost(self:GetLevel())

    local modif = caster:FindModifierByName("modifier_lord_blood_rage")
    modif:SetStackCount(modif:GetStackCount() - healthCost)    
    
    caster:AddNewModifier(caster,self,"modifier_lord_remove_restriction_before", {duration = 2})
    EmitSoundOn("rest", caster)
end


modifier_lord_remove_restriction = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,
})

function modifier_lord_remove_restriction:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.stack = self:GetAbility():GetSpecialValueFor("stack")

    self:SetStackCount(self.stack)

    local particle_cast = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 

    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )

end 
 

function modifier_lord_remove_restriction:OnAttackLanded(keys)
    local parent = self:GetParent()
    local attacker = keys.attacker
    local target = keys.target
    if attacker == parent then 
       
         
        self:SetStackCount(self:GetStackCount() - 1)
    local units = FindUnitsInRadius(
            self:GetParent():GetTeam(),
            target:GetAbsOrigin(),
            nil,
            self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,
            false
        )
        for _, unit in pairs( units ) do
        local damage = keys.damage * (self:GetAbility():GetSpecialValueFor("damage_pct")/100)

        ApplyDamage( { victim = unit, attacker = self:GetParent(), damage = damage,
                        damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()} )
        
    end
      if self:GetStackCount() <= 0 then 
            parent:RemoveModifierByName("modifier_lord_remove_restriction")
        end
     end
end
 
 

modifier_lord_remove_restriction_before = class({
     IsHidden                 = function(self) return true end,
     IsPurgable                 = function(self) return false end,
     IsDebuff                 = function(self) return false end,
     IsBuff                  = function(self) return true end,
     RemoveOnDeath             = function(self) return false end,
         DeclareFunctions        = function(self) return 
        {
     MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
                                MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
                    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
                    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,

        } end,
      CheckState      = function(self) return 
         {
            [MODIFIER_STATE_STUNNED] = true, 

         } end,
 })
 
 

function modifier_lord_remove_restriction_before:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_lord_remove_restriction_before:GetAbsoluteNoDamageMagical()
    return 1
end


function modifier_lord_remove_restriction_before:GetAbsoluteNoDamagePhysical()
    return 1
end
 
function modifier_lord_remove_restriction_before:OnDestroy()
        self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_lord_remove_restriction", {})
end