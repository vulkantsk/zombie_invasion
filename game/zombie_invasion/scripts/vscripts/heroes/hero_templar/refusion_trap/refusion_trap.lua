LinkLuaModifier("modifier_refusion_trap_infinity", "heroes/hero_templar/refusion_trap/refusion_trap", LUA_MODIFIER_MOTION_NONE)

refusion_trap = {}

function refusion_trap:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()

	local unit = CreateUnitByName("npc_templar_trap", point, true, nil, nil, DOTA_TEAM_BADGUYS)  
	 unit:AddNewModifier(unit, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})

	unit:AddNewModifier(caster,self,"modifier_refusion_trap_infinity", {})

end

modifier_refusion_trap_infinity = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        	MODIFIER_PROPERTY_MIN_HEALTH
        } end,	
    CheckState      = function(self) return 
        {          
            [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
        } end,
})

function modifier_refusion_trap_infinity:GetMinHealth()
    return 1
end

function modifier_refusion_trap_infinity:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_refusion_trap_infinity:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_refusion_trap_infinity:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_refusion_trap_infinity:OnAttackLanded(params)

    local victim = params.target
    local attacker = params.attacker

    if victim == self:GetParent() and attacker == self:GetCaster() then 
    	local enemies = FindUnitsInRadius(
        	self:GetCaster():GetTeamNumber(), -- int, your team number
        	self:GetParent():GetOrigin(), -- point, center point
        	nil, -- handle, cacheUnit. (not known)
        	self:GetAbility():GetSpecialValueFor("radius"), -- fsloat, radius. or use FIND_UNITS_EVERYWHERE
        	DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
        	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        	self:GetAbility():GetAbilityTargetFlags(), -- int, flag filter
        	0, -- int, order filter
        	false -- bool, can grow cache
        )

        local count = 0
        for _,enemy in pairs(enemies) do
        	if enemy ~= self:GetParent() and count < self:GetAbility():GetSpecialValueFor("count") then   
        	local info = {
				Target = enemy,
				Source = self:GetParent(),
				Ability = self:GetAbility(),	
				
				EffectName = self:GetCaster():GetRangedProjectileName(),
				iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,		
	
				bDodgeable = true,                           -- Optional
				bIsAttack = true,                                -- Optional

				ExtraData = {},
			}

        	ProjectileManager:CreateTrackingProjectile( info )
        	count = count + 1
       		 end
        end
    end
end


function refusion_trap:OnProjectileHit(Target, Location)  
    if Target ~= nil and not Target:IsInvulnerable() then

 		 self:GetCaster():PerformAttack(Target, true, true, true, false, false, false, true)
   
    end
    return true
end

function modifier_refusion_trap_infinity:OnDestroy()  
    self:GetParent():AddNoDraw()
end