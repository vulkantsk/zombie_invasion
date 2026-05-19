lycan_boss_claw_lunge = class({})

function lycan_boss_claw_lunge:Precache(context)
	PrecacheAbilityResources({
		"particles/darkmoon_creep_warning.vpcf",
		"particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_smoke_ti5.vpcf",
		"particles/generic_gameplay/generic_bashed.vpcf",
		"particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf",
		"particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf",
		"particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
	}, {
		"EGE",
		"Hero_Bristleback.QuillSpray.Cast",
		"Hero_Lycan.Howl",
	}, context)
end

LinkLuaModifier( "modifier_lycan_boss_claw_lunge", "modifiers/modifier_lycan_boss_claw_lunge", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_no_heal", "modifiers/modifier_no_heal", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_bkb", "modifiers/modifier_bkb", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_generic_bashed_lua", "heroes/generic/modifier_generic_bashed_lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function lycan_boss_claw_lunge:OnAbilityPhaseStart()
	if IsServer() then
	 		 self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bkb", {duration = 2})
		EmitSoundOn( "Hero_Lycan.Howl", self:GetCaster() )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 188, 26, 26 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function lycan_boss_claw_lunge:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveGesture( ACT_DOTA_ATTACK )
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
 
	end 
end

--------------------------------------------------------------------------------

function lycan_boss_claw_lunge:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )
		self:GetCaster():RemoveGesture( ACT_DOTA_ATTACK )

		self.lunge_speed = self:GetSpecialValueFor( "lunge_speed" )
		self.lunge_width = self:GetSpecialValueFor( "lunge_width" )
		self.lunge_distance = self:GetSpecialValueFor( "lunge_distance" )
		self.lunge_damage = self:GetSpecialValueFor( "lunge_damage" ) 
		
		EmitSoundOn( "EGE", self:GetCaster() )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.vProjectileLocation = self:GetCaster():GetOrigin() -- + ( vDirection * 100 )

		local info = {
			EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
			Ability = self,
			vSpawnOrigin = self.vProjectileLocation, 
			fStartRadius = self.lunge_width,
			fEndRadius = self.lunge_width,
			vVelocity = vDirection * self.lunge_speed,
			fDistance = self.lunge_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( info )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_lycan_boss_claw_lunge", {} )
		--EmitSoundOn( "Hero_Bristleback.QuillSpray.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function lycan_boss_claw_lunge:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			if hTarget:IsInvulnerable() == false then
				    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_no_heal", {duration = 12})
 				    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_generic_bashed_lua", {duration = 0.75})
				local damageInfo =
				{
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = self.lunge_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self,
				}
				ApplyDamage( damageInfo )
			end
		else
			local hBuff = self:GetCaster():FindModifierByName( "modifier_lycan_boss_claw_lunge" )
			if hBuff ~= nil then
				hBuff:Destroy()
			end
		end
	end

	return false
end

--------------------------------------------------------------------------------

function lycan_boss_claw_lunge:OnProjectileThink( vLocation )
	if IsServer() then
		self.vProjectileLocation = vLocation
	end
end

--------------------------------------------------------------------------------