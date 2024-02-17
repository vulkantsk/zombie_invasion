LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom", "heroes/hero_templar/psi_blades/psi_blades", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_speed", "heroes/hero_templar/psi_blades/psi_blades", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_psi", "heroes/hero_templar/psi_blades/psi_blades", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_attack", "heroes/hero_templar/psi_blades/psi_blades", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_custom", "heroes/hero_templar/psi_blades/psi_blades", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_attack_ready", "heroes/hero_templar/psi_blades/psi_blades", LUA_MODIFIER_MOTION_NONE )



templar_assassin_psi_blades_custom = class({})


function templar_assassin_psi_blades_custom:GetIntrinsicModifierName()
	return "modifier_templar_assassin_psi_blades_custom"
end


function templar_assassin_psi_blades_custom:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function templar_assassin_psi_blades_custom:OnSpellStart()
if not IsServer() then return end

local target = self:GetCursorTarget()
local direction = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
local length = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
local pos = self:GetCaster():GetAbsOrigin() + direction*math.min(self.legendary_range, length/2)


local crystal = CreateUnitByName("npc_psi_blades_crystal", pos, true, nil, nil, target:GetTeamNumber())



crystal:EmitSound("Lina.Array_triple")
local particle_peffect = ParticleManager:CreateParticle("particles/ta_crystall_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, crystal)
ParticleManager:SetParticleControl(particle_peffect, 0, crystal:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, crystal:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)



end



modifier_templar_assassin_psi_blades_custom = class({})

function modifier_templar_assassin_psi_blades_custom:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom:IsHidden() return true end

function modifier_templar_assassin_psi_blades_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end








function modifier_templar_assassin_psi_blades_custom:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range") + bonus
end




function modifier_templar_assassin_psi_blades_custom:OnTakeDamage(params)
if not IsServer() then return end

if params.attacker ~= self:GetParent() then return end
if params.unit:IsBuilding() then return end
if params.inflictor then return end
if self:GetParent():PassivesDisabled() then return end





params.unit:EmitSound("Hero_TemplarAssassin.PsiBlade")

local direction = params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
direction.z = 0
direction = direction:Normalized()

local distance = self:GetAbility():GetSpecialValueFor("attack_spill_range")

local attack_spill_width = self:GetAbility():GetSpecialValueFor("attack_spill_width")
local attack_spill_pct = self:GetAbility():GetSpecialValueFor("attack_spill_pct")/100

local damage = params.damage


local enemies


	enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),  params.unit:GetAbsOrigin() + direction * distance , params.unit:GetAbsOrigin() + direction*attack_spill_width, self:GetCaster(), attack_spill_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)


local hit_units = {}


damage = damage*attack_spill_pct

local hit = false
for _, enemy in pairs(enemies) do
    

		hit = true
    	self:DealDamage(damage, enemy, params.unit)
	
		hit_units[enemy:entindex()] = true
   
end





end




function modifier_templar_assassin_psi_blades_custom:DealDamage(damage, enemy, unit)


local creeps_k = 1

if enemy:IsCreep() then 
--	creeps_k = self:GetAbility():GetSpecialValueFor("creeps_damage")/100
end

local k = 1




local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = damage*creeps_k*k, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})

end







modifier_templar_assassin_psi_blades_custom_speed = class({})
function modifier_templar_assassin_psi_blades_custom_speed:IsHidden() return false end
function modifier_templar_assassin_psi_blades_custom_speed:IsPurgable() return true end
function modifier_templar_assassin_psi_blades_custom_speed:GetTexture() return "buffs/psiblades_speed" end

function modifier_templar_assassin_psi_blades_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_templar_assassin_psi_blades_custom_speed:GetModifierEvasion_Constant()
return
self:GetAbility().speed_evasion*self:GetStackCount()
end

function modifier_templar_assassin_psi_blades_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return
self:GetAbility().speed_move*self:GetStackCount()
end

function modifier_templar_assassin_psi_blades_custom_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_templar_assassin_psi_blades_custom_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().speed_max then 

	local effect_cast = ParticleManager:CreateParticle( "particles/ta_psi_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
	self:AddParticle( effect_cast, false, false, -1, false, false)
end


end

modifier_templar_assassin_psi_blades_custom_attack = class({})
function modifier_templar_assassin_psi_blades_custom_attack:IsHidden() 
	return true
end

function modifier_templar_assassin_psi_blades_custom_attack:RemoveOnDeath() return false end
function modifier_templar_assassin_psi_blades_custom_attack:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_attack:GetTexture() return "buffs/psiblades_attack" end

function modifier_templar_assassin_psi_blades_custom_attack:OnCreated(table)
self.cd = false
if not IsServer() then return end
self.origin = nil
self.record = nil
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_attack_ready", {})
end

function modifier_templar_assassin_psi_blades_custom_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_RECORD,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end







function modifier_templar_assassin_psi_blades_custom_attack:OnAttack(params)
if params.target:IsBuilding() then return end
if self.cd == true then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if (self:GetParent():GetAbsOrigin() - params.target:GetAbsOrigin()):Length2D() >= self:GetAbility().knockback_meele then return end

        local projectile =
        {
            Target = params.target,
            Source = self:GetParent(),
            Ability = self:GetAbility(),
            EffectName = "particles/templar_assassin_knockback.vpcf",
            iMoveSpeed = self:GetParent():GetProjectileSpeed()*0.7,
            vSourceLoc = self:GetParent():GetAbsOrigin(),
            bDodgeable = false,
            bProvidesVision = false,
        }

        local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )

self.origin = self:GetCaster():GetAbsOrigin()
self.record = params.record

self.cd = true
self:GetCaster():RemoveModifierByName("modifier_templar_assassin_psi_blades_custom_attack_ready")
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_attack_cd", {duration = self:GetAbility().knockback_cd})
self:StartIntervalThink(self:GetAbility().knockback_cd)
end


function modifier_templar_assassin_psi_blades_custom_attack:OnIntervalThink()
self.cd = false
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_attack_ready", {})

end





function modifier_templar_assassin_psi_blades_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.record ~= self.record then return end


if params.target:IsBuilding() or
	params.target:GetUnitName() == "npc_teleport" or
	params.target:GetUnitName() == "npc_psi_blades_crystal" or
	params.target:GetUnitName() == "npc_psi_blades_crystal_mini" then return end
	
params.target:EmitSound("TA.Psibaldes_knockback")

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_psi", {duration =  self:GetAbility().knockback_slow_duration*(1 - params.target:GetStatusResistance())})

params.target:AddNewModifier(
	self:GetCaster(),
	self:GetAbility(),
	"modifier_generic_knockback_custom",
	{	
		duration = self:GetAbility().knockback_duration, 
		min_distance = self:GetAbility().knockback_min_distance,
		max_distance = self:GetAbility().knockback_max_distance,
		x = self.origin.x, 
		y = self.origin.y
	})
			
end



modifier_templar_assassin_psi_blades_custom_attack_ready = class({})
function modifier_templar_assassin_psi_blades_custom_attack_ready:IsHidden() return false end
function modifier_templar_assassin_psi_blades_custom_attack_ready:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_attack_ready:GetTexture() return "buffs/psiblades_attack" end
function modifier_templar_assassin_psi_blades_custom_attack_ready:RemoveOnDeath() return false end
