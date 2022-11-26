axe_culling_blade_lua = class({})
LinkLuaModifier( "modifier_scepter_culling_blade", "heroes/hero_axe/rubilka/axe_culling_blade_lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_scepter_culling_blade_stack", "heroes/hero_axe/rubilka/axe_culling_blade_lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start

   function axe_culling_blade_lua:GetCooldown( level )
    local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_axe_culling_cooldown")
    if talent:GetLevel() == 1  then
        return self.BaseClass.GetCooldown( self, level ) - talent:GetSpecialValueFor( "value" )
    end

    return self.BaseClass.GetCooldown( self, level )
   end
   
function axe_culling_blade_lua:GetAOERadius()
 
	return self:GetSpecialValueFor( "splash_radius" )
	 
end

function axe_culling_blade_lua:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

 
	-- load data
	local damage_attack = self:GetSpecialValueFor("damage_attack")
 	local damage_base = self:GetSpecialValueFor("damage")

 	local duration_scepter = self:GetSpecialValueFor("duration_scepter")
 	local bonus_base = self:GetSpecialValueFor("bonus_base")
  	local bonus_kill = self:GetSpecialValueFor("bonus_kill")

	local damage = ( caster:GetBaseDamageMax() * (damage_attack/ 100) )  + damage_base
 
  	local bonus
     if caster:HasScepter() then 
 
          local modif_scept =  caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_scepter_culling_blade", -- modifier name
			{ duration = duration_scepter } -- kv
		)
	 
		bonus = bonus_base
 
 

        local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_scepter_culling_blade_stack", -- modifier name
		{ duration = duration_scepter } -- kv
	)

	modifier.parent = modif_scept
	modifier.bonus = bonus
 
	-- add duration
 

        modif_scept:SetStackCount( modif_scept:GetStackCount() + bonus )

        modif_scept:SetDuration( duration_scepter, true )
     
     
     end 
 

	-- Check success / not
	local success = false
	if target:GetHealth()<=damage and target:IsAlive() then success = true end

 	self:PlayEffects( target, success )
	if success then
		-- Success:
		-- Damage as HPLoss 
	local search = self:GetSpecialValueFor("splash_radius")

	-- find targets
	local targets = {}
 
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
 

	for _,enemy in pairs(targets) do
		-- delay
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self, --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
		}
				ApplyDamage(damageTable)
 
     if caster:HasScepter() then 
     	if enemy:GetHealth() <= damage then 
          local modif_scept =  caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_scepter_culling_blade", -- modifier name
			{ duration = duration_scepter } -- kv
		)
 
		bonus = bonus_kill
 
        local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_scepter_culling_blade_stack", -- modifier name
		{ duration = duration_scepter } -- kv
	)

	modifier.parent = modif_scept
	modifier.bonus = bonus

        modif_scept:SetStackCount( modif_scept:GetStackCount() + bonus )

        modif_scept:SetDuration( duration_scepter, true )
     
     	end
     end
 
	end

 
 
	else
		-- Failed
		-- Magical damage
 

	local search = self:GetSpecialValueFor("splash_radius")

	-- find targets
	local targets = {}
 
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
 

	for _,enemy in pairs(targets) do
		-- delay
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self, --Optional.
		}
				ApplyDamage(damageTable)
 
      if caster:HasScepter() then 
     	if enemy:GetHealth() <= damage then 
          local modif_scept =  caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_scepter_culling_blade", -- modifier name
			{ duration = duration_scepter } -- kv
		)
 
		bonus = bonus_kill
 
        local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_scepter_culling_blade_stack", -- modifier name
		{ duration = duration_scepter } -- kv
	)

	modifier.parent = modif_scept
	modifier.bonus = bonus

        modif_scept:SetStackCount( modif_scept:GetStackCount() + bonus )

        modif_scept:SetDuration( duration_scepter, true )
     
     	end
     end
 
	end

 

	end
end

--------------------------------------------------------------------------------
function axe_culling_blade_lua:PlayEffects( target, success )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""
	if success then
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		sound_cast = "Hero_Axe.Culling_Blade_Success"
	else
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
		sound_cast = "Hero_Axe.Culling_Blade_Fail"
	end

	-- load data
	local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
	ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
	-- assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_target)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end










modifier_scepter_culling_blade = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_scepter_culling_blade:IsHidden()
	return false
end

function modifier_scepter_culling_blade:IsDebuff()
	return false
end

function modifier_scepter_culling_blade:IsPurgable()
	return false
end

  

--------------------------------------------------------------------------------
-- Initializations
function modifier_scepter_culling_blade:OnCreated( kv )
	-- references
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "atk_speed_bonus_tooltip" ) -- special value
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" ) -- special value
end

function modifier_scepter_culling_blade:OnRefresh( kv )
	-- references
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "atk_speed_bonus_tooltip" ) -- special value
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" ) -- special value
end
 

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_scepter_culling_blade:DeclareFunctions()
	local funcs = {
       MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end
function modifier_scepter_culling_blade:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end
 

function modifier_scepter_culling_blade:RemoveStack( value )
	self:SetStackCount( self:GetStackCount() - value )
end

 



modifier_scepter_culling_blade_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_scepter_culling_blade_stack:IsHidden()
	return true
end

function modifier_scepter_culling_blade_stack:IsDebuff()
	return false
end

function modifier_scepter_culling_blade_stack:IsPurgable()
	return false
end

function modifier_scepter_culling_blade_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_scepter_culling_blade_stack:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_scepter_culling_blade_stack:OnCreated( kv )

end

function modifier_scepter_culling_blade_stack:OnRefresh( kv )
	
end

function modifier_scepter_culling_blade_stack:OnRemoved()
end

function modifier_scepter_culling_blade_stack:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveStack( self.bonus )
end