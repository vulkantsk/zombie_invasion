smash_of_mutant = class({})
LinkLuaModifier( "modifier_smash_of_mutant", "abilities/zombie/boss/smash_of_mutant", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function smash_of_mutant:Precache( context )

	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )

end

--------------------------------------------------------------------------------

function smash_of_mutant:GetIntrinsicModifierName()
	return "modifier_smash_of_mutant"
end

modifier_smash_of_mutant = class({})

--------------------------------------------------------------------------------

function modifier_smash_of_mutant:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_smash_of_mutant:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_smash_of_mutant:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_smash_of_mutant:OnCreated( kv )
	self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
end

--------------------------------------------------------------------------------

function modifier_smash_of_mutant:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_smash_of_mutant:OnAttackLanded( params )
	if IsServer() then
		if self:GetAbility() == nil or self:GetAbility():IsCooldownReady() == false then 
			return 0 
		end

		local Attacker = params.attacker
		local Target = params.target
		
		if Attacker ~= nil and Attacker == self:GetParent() and Attacker:IsRangedAttacker() == false and Target ~= nil then
			self:GetAbility():StartCooldown( 0.05 )

 
			EmitSoundOn( "Hero_EarthSpirit.BoulderSmash.Target", Target )
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, Attacker )
			ParticleManager:SetParticleControl( nFXIndex, 0, Target:GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.damage_radius, self.damage_radius, self.damage_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( Attacker:GetTeamNumber(), Target:GetOrigin(), Attacker, self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					if enemy ~= Target then
						local damageInfo = 
						{
							victim = enemy,
							attacker = Attacker,
							damage = params.original_damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self:GetAbility(),
						}
						ApplyDamage( damageInfo )
					end
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -Attacker:GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact.Lesser", enemy )
					else
						enemy:AddNewModifier( Attacker, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration * (1-Target:GetStatusResistance())} )
					end
				end
			end
		end
	end

	return 0
end