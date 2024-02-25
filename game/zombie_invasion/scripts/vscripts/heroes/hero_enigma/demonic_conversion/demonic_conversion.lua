ability_demonic_conversion = {}

LinkLuaModifier( "modifier_ability_demonic_conversion", "heroes/hero_enigma/demonic_conversion/demonic_conversion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_demonic_conversion_damage", "heroes/hero_enigma/demonic_conversion/demonic_conversion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_demonic_conversion_stats", "heroes/hero_enigma/demonic_conversion/demonic_conversion", LUA_MODIFIER_MOTION_NONE )

function ability_demonic_conversion:GetCooldown( level )
    local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_enigma_demonic_conversion_cooldown")
    if talent:GetLevel() == 1  then
        return self.BaseClass.GetCooldown( self, level ) - talent:GetSpecialValueFor( "value" )
    end

    return self.BaseClass.GetCooldown( self, level )
end
   
 
function ability_demonic_conversion:OnSpellStart()
	local caster = self:GetCaster()
 	local ability = self
 
	self.sound_cast = "Hero_Enigma.demonic_conversion"
		EmitSoundOn( self.sound_cast, caster )
	for i = 1, ability:GetSpecialValueFor( "spawn_count" ) do 
		self:CreateEidolon( caster:GetAbsOrigin(), true, ability:GetSpecialValueFor( "eidalon_duration_spawn" ) )
	end
end

function ability_demonic_conversion:CreateEidolon( pos, ve, duration )
	local caster = self:GetCaster()
	local ability = self
	local damage = ability:GetSpecialValueFor( "eidolon_dmg_tooltip" )
	local health = ability:GetSpecialValueFor( "eidolon_hp_tooltip" ) + caster:GetStrength() * ability:GetSpecialValueFor( "bonus_str" )
 
	local eidolon = CreateUnitByName( "npc_classic_eidolon", pos, true, caster, caster, caster:GetTeamNumber() )
 
    eidolon:SetMaxHealth(health)
    eidolon:SetHealth(eidolon:GetMaxHealth())
	eidolon:SetBaseDamageMin(damage)	
	eidolon:SetBaseDamageMax(damage)	
 
	eidolon:AddNewModifier( caster, self, "modifier_ability_demonic_conversion", { duration = self:GetSpecialValueFor( "eidalon_duration" ), ve = ve } )
	eidolon:AddNewModifier( caster, self, "modifier_kill", { duration = self:GetSpecialValueFor( "eidalon_duration" ) } )
	eidolon:SetOwner( caster )
	eidolon:SetControllableByPlayer( caster:GetPlayerID(), true )
	FindClearSpaceForUnit( eidolon, pos, true )

  
	local talent = self:GetCaster():FindAbilityByName( "special_bonus_unique_enigma_3" )

         eidolon:AddNewModifier( caster, self, "modifier_ability_demonic_conversion_stats", {} )


--[[ 
	if talent and talent:GetLevel() > 0 then
		eidolon:AddNewModifier( caster, talent, "modifier_ability_demonic_conversion_damage", {} )
	end
]]
	return eidolon
end

modifier_ability_demonic_conversion = {}

function modifier_ability_demonic_conversion:IsDebuff()
	return true
end

function modifier_ability_demonic_conversion:OnCreated( data )
	local ability = self:GetAbility()
	
	if data.ve then
		self.attacks = ability:GetSpecialValueFor( "split_attack_count" )
	end

	self.damage = ability:GetSpecialValueFor( "eidolon_dmg_tooltip" )
end

function modifier_ability_demonic_conversion:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_ability_demonic_conversion:OnAttackLanded( data )
	if self.attacks and data.attacker == self:GetParent() then
		if self.attacks > 1 then
			self.attacks = self.attacks - 1
		else
			local parent = self:GetParent()
			local pos = parent:GetAbsOrigin()
			local ability = self:GetAbility()

			ability:CreateEidolon( pos, true, self:GetRemainingTime() )
			ability:CreateEidolon( pos, nil, self:GetRemainingTime() )
			
			parent:ForceKill( false )
		end
	end
end

modifier_ability_demonic_conversion_damage = {}

function modifier_ability_demonic_conversion_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_ability_demonic_conversion_damage:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor( "value" )
end


modifier_ability_demonic_conversion_stats = {}

 


function modifier_ability_demonic_conversion_stats:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

--function modifier_ability_demonic_conversion_stats:GetModifierHealthBonus()
	--return self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor( "bonus_str" )
--end

function modifier_ability_demonic_conversion_stats:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor( "bonus_ag" )
end

function modifier_ability_demonic_conversion_stats:GetModifierPreAttack_BonusDamage()
	return self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor( "bonus_int" )
end
 