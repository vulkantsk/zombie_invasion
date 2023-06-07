LinkLuaModifier( "modifier_snowball_debuff", "heroes/hero_yuki-onna/snowball" ,LUA_MODIFIER_MOTION_NONE )


 yuki_snowball = {}

 function yuki_snowball:OnSpellStart()
 	local target = self:GetCursorTarget()
 	local caster = self:GetCaster()

    local info = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "particles/econ/events/snowball/snowball_projectile.vpcf",
        bDodgeable = true,
        bProvidesVision = true,
        iMoveSpeed = 600,
        iVisionRadius = 450,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }

    ProjectileManager:CreateTrackingProjectile( info )
    EmitSoundOn("FrostivusConsumable.Snowball.Target", caster)

 end
  

function yuki_snowball:OnProjectileHit(Target, Location)
       local spell = self:GetCaster():FindAbilityByName("yuki_snowball")
        local radius = self:GetSpecialValueFor("radius")
        local heal = self:GetSpecialValueFor("heal")
    if Target ~= nil and not Target:IsInvulnerable() then

        if Target:TriggerSpellAbsorb(self) then return end

        local units = FindUnitsInRadius(
            self:GetCaster():GetTeam(),
            Target:GetAbsOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
            FIND_CLOSEST,
            false
        )

        for _, unit in pairs( units ) do
            if unit:GetTeam() == self:GetCaster():GetTeam() then
                unit:Heal(heal, self)
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, heal, nil)
            else 
                unit:AddNewModifier(self:GetCaster(), self, "modifier_snowball_debuff", {duration = self:GetSpecialValueFor("duration")})
            end
        end            
            
   
        end
    return true
end  

modifier_snowball_debuff = class({
    IsHidden                 = function(self) return false end,
    IsPurgable                 = function(self) return true end,
    IsDebuff                 = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath             = function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        } end,
})

function modifier_snowball_debuff:GetModifierAttackSpeedBonus_Constant() 
    return self:GetAbility():GetSpecialValueFor("slow_as")
end

function modifier_snowball_debuff:GetEffectName()
    return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end