LinkLuaModifier( "modifier_shotgun_turel", "heroes/hero_tech/tech_mehanoid_turel", LUA_MODIFIER_MOTION_NONE )


tech_mehanoid_turel = class({})

function tech_mehanoid_turel:Precache(context)
	PrecacheAbilityResources({
	}, {
		"Hero_Medusa.AttackSplit",
	}, context)
end


function tech_mehanoid_turel:OnSpellStart() 
	local caster = self:GetCaster()
	local point_for_unit = self:GetCursorPosition()
	local bonus_health = self:GetSpecialValueFor("bonus_health")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")
	local duration = self:GetSpecialValueFor("duration")

	if caster.mehTurret and IsValidEntity(caster.mehTurret) and caster.mehTurret:IsAlive() then 
		caster.mehTurret:AddNewModifier(caster.mehTurret, self, "modifier_shotgun_turel", {})
		FindClearSpaceForUnit(caster.mehTurret, point_for_unit, true)

		caster.mehTurret:SetBaseMaxHealth(bonus_health)

		caster.mehTurret:SetMaxHealth(bonus_health )
		caster.mehTurret:SetHealth(bonus_health )		
		caster.mehTurret:SetBaseDamageMin(bonus_damage)	
		caster.mehTurret:SetBaseDamageMax(bonus_damage)
		caster.mehTurret:SetTimeUntilRespawn(-1)
	elseif caster.mehTurret and IsValidEntity(caster.mehTurret) and not caster.mehTurret:IsAlive() then 
		caster.mehTurret:AddNewModifier(caster.mehTurret, self, "modifier_shotgun_turel", {})
		FindClearSpaceForUnit(caster.mehTurret, point_for_unit, true)
		caster.mehTurret:RespawnUnit()
			caster.mehTurret:SetBaseMaxHealth(bonus_health)
					caster.mehTurret:SetMaxHealth(bonus_health )
		caster.mehTurret:SetHealth(bonus_health )	
	caster.mehTurret:SetBaseDamageMin(bonus_damage)	
	caster.mehTurret:SetBaseDamageMax(bonus_damage)
	caster.mehTurret:SetTimeUntilRespawn(-1)
	else 
	caster.mehTurret = CreateUnitByName("npc_mechanical_turret", point_for_unit, true, caster, caster, caster:GetTeamNumber())

    caster.mehTurret:AddNewModifier(caster.mehTurret, self, "modifier_shotgun_turel", {})
	caster.mehTurret:SetOwner( caster )
	caster.mehTurret:SetControllableByPlayer( caster:GetPlayerID(), true )
	FindClearSpaceForUnit( caster.mehTurret, point_for_unit, true )
	caster.mehTurret:SetBaseMaxHealth(bonus_health)
	caster.mehTurret:SetBaseDamageMin(bonus_damage)	
	caster.mehTurret:SetBaseDamageMax(bonus_damage)
	caster.mehTurret:SetTimeUntilRespawn(-1)
	end
end


 function tech_mehanoid_turel:OnProjectileHit( target, location )
	if not target then return end

	-- perform attack
	self.split_shot_attack = true
	self:GetCaster():PerformAttack(
		target, -- hTarget
		false, -- bUseCastAttackOrb
		false, -- bProcessProcs
		true, -- bSkipCooldown
		false, -- bIgnoreInvis
		false, -- bUseProjectile
		false, -- bFakeAttack
		false -- bNeverMiss
	)
	self.split_shot_attack = false
end
 

 
 modifier_shotgun_turel = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	GetPriority  			= function(self) return MODIFIER_PRIORITY_HIGH end,
    DeclareFunctions        = function(self) return 
        {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        } end,
})


function modifier_shotgun_turel:OnCreated( kv )
	-- references
	self.count = self:GetAbility():GetSpecialValueFor( "arrow_count" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "split_shot_bonus_range" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )

	self.parent = self:GetParent()
 
	if not IsServer() then return end
	self.projectile_name = self.parent:GetRangedProjectileName()
	self.projectile_speed = self.parent:GetProjectileSpeed()
end

function modifier_shotgun_turel:OnRefresh( kv )
	-- references
	self.count = self:GetAbility():GetSpecialValueFor( "arrow_count" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "split_shot_bonus_range" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )

end

function modifier_shotgun_turel:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_shotgun_turel:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self.parent then return end

	-- not proc for instant attacks
	if params.no_attack_cooldown then return end

	-- not proc for attacking allies
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

	-- not proc if break
	if self.parent:PassivesDisabled() then return end

	-- not proc if attack can't use attack modifiers
	if not params.process_procs then return end

	-- not proc on split shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
	if self.split_shot then return end
 
	self:SplitShotModifier( params.target )
 
end

function modifier_shotgun_turel:SplitShotModifier( target )
	-- get radius
	local radius = self.parent:Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then

			-- perform attack
			self.split_shot = true
			self.parent:PerformAttack(
				enemy, -- hTarget
				false, -- bUseCastAttackOrb
				true, -- bProcessProcs
				true, -- bSkipCooldown
				false, -- bIgnoreInvis
				true, -- bUseProjectile
				false, -- bFakeAttack
				false -- bNeverMiss
			)
			self.split_shot = false

			count = count + 1
			if count>=self.count then break end
		end
	end

	-- play effects if splitshot
	if count>0 then
		local sound_cast = "Hero_Medusa.AttackSplit"
		EmitSoundOn( sound_cast, self.parent )
	end
end

