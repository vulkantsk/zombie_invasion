ability_sunflame = class({})
 
--------------------------------------------------------------------------------
-- Ability Start
function ability_sunflame:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- unit target just indicates point
	if target then point = target:GetOrigin() end

	local value1 = self:GetSpecialValueFor("some_value")
	local damage    
	local unduced   
	local projectile_name 

	if self:GetCaster():HasModifier("modifier_ability_metamorphosis") then 
		projectile_name = "particles/heroes/dragon_knight_breathe_fire_meta.vpcf"
		damage = self:GetSpecialValueFor( "damage_meta" )
		unduced =(self:GetSpecialValueFor( "unduced_meta" )/100) + 1 		
	else
		projectile_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
		damage = self:GetSpecialValueFor( "damage" )
		unduced =(self:GetSpecialValueFor( "unduced" )/100) + 1
	end
	 
	-- load projectile
 	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_start_radius = self:GetSpecialValueFor( "start_radius" )
	local projectile_end_radius = self:GetSpecialValueFor( "end_radius" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_direction = point - caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}
 
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage
	self.projectiles[projectile].unduced = unduced


	-- play effects
	local sound_cast = "Hero_DragonKnight.BreathFire"
	EmitSoundOn( sound_cast, caster )
end

ability_sunflame.projectiles = {}
--------------------------------------------------------------------------------
-- Projectile
function ability_sunflame:OnProjectileHitHandle( target, location, handle )
	if not target then return end

	-- load data
	local stack_overhell = self:GetSpecialValueFor( "stack_overhell" )

	-- get data
	local data = self.projectiles[handle]
	local damage = data.damage

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage * target:DamageHell(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	data.damage = damage * data.unduced

	ApplyDamage(damageTable)

    target:ModifierStackInc("modifier_overheating", stack_overhell,8,stack_overhell,self)

end