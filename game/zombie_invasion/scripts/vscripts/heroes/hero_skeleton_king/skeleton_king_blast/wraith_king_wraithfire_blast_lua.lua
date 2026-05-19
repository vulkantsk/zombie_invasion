wraith_king_wraithfire_blast_lua = class({})

function wraith_king_wraithfire_blast_lua:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_stunned.vpcf",
		"particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf",
		"particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf",
	}, {
		"Hero_SkeletonKing.Hellfire_Blast",
		"Hero_SkeletonKing.Hellfire_BlastImpact",
	}, context)
end

LinkLuaModifier("modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_wraithfire_blast_lua_slow", "heroes/hero_skeleton_king/skeleton_king_blast/modifier_wraith_king_wraithfire_blast_lua_slow", LUA_MODIFIER_MOTION_NONE )

function wraith_king_wraithfire_blast_lua:OnSpellStart()
	-- get references
	local target = self:GetCursorTarget()
	local projectile_speed = self:GetSpecialValueFor("blast_speed")
	local projectile_name = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf"

	-- create tracking projectile
	local info = {
		EffectName = projectile_name,
		Ability = self,
		iMoveSpeed = projectile_speed,
		Source = self:GetCaster(),
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}
	ProjectileManager:CreateTrackingProjectile( info )

	self:PlayEffects1()
end

function wraith_king_wraithfire_blast_lua:OnProjectileHit( hTarget, vLocation )
	-- check target
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsMagicImmune() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		local caster = self:GetCaster()		
		local stun_duration = self:GetSpecialValueFor( "blast_stun_durationn" )
		local base_dmg = self:GetSpecialValueFor("base_dmg")
		local str_dmg = self:GetSpecialValueFor("str_dmg")/100
		local stun_damage = caster:GetAverageTrueAttackDamage(caster) * str_dmg + base_dmg 
		local dot_duration = self:GetSpecialValueFor( "blast_dot_durationn" )

		-- apply initial damage
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = stun_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage( damage )

		-- apply stun debuff
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )
		
		-- apply slow debuff
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_wraith_king_wraithfire_blast_lua_slow", { duration = dot_duration } )

		self:PlayEffects2( hTarget )
	end

	return true
end

function wraith_king_wraithfire_blast_lua:PlayEffects1()
	-- get resource
	local sound_cast = "Hero_SkeletonKing.Hellfire_Blast"

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function wraith_king_wraithfire_blast_lua:PlayEffects2( target )
	-- get resource
	local sound_impact = "Hero_SkeletonKing.Hellfire_BlastImpact"

	-- play sound
	EmitSoundOn( sound_impact, target )
end