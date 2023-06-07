 LinkLuaModifier( "modifier_ritual_buff", "heroes/hero_yuki-onna/ritual", LUA_MODIFIER_MOTION_NONE )


 yuki_ritual = {}
 
function yuki_ritual:OnAbilityPhaseStart()
	local particle_cast = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf"
    
	local caster = self:GetCaster()

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
 

	ParticleManager:SetParticleControl( self.effect_cast, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( radius, 0, 0 ) )
	EmitSoundOn("hero_Crystal.freezingField.wind", caster)
	 
end 

function yuki_ritual:OnAbilityPhaseInterrupted()
		local caster = self:GetCaster()

	ParticleManager:DestroyParticle( self.effect_cast, false )
	StopSoundOn("hero_Crystal.freezingField.wind", caster)


end 
function yuki_ritual:OnSpellStart() 
	local caster = self:GetCaster()
	local radius = self:GetCastRange(caster:GetAbsOrigin(),caster)
	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius ,DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )


	for _, unit in pairs( units ) do
		unit:AddNewModifier(caster,self,"modifier_ritual_buff",{duration = self:GetSpecialValueFor('duration')})
	end
	ParticleManager:DestroyParticle( self.effect_cast, false )

 
	 	StopSoundOn("hero_Crystal.freezingField.wind", caster)

end

 
 modifier_ritual_buff = class({
 	IsHidden 				= function(self) return false end,
 	IsPurgable 				= function(self) return false end,
 	IsDebuff 				= function(self) return false end,
 	IsBuff                  = function(self) return true end,
 	RemoveOnDeath 			= function(self) return true end,
     DeclareFunctions        = function(self) return 
         {
 			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
 			MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
 			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
 			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

         } end,
         GetEffectName = function(self) return "particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf" end
          
 
 })

function modifier_ritual_buff:OnCreated()
	self.armor = (self:GetAbility():GetSpecialValueFor('bonus_armor') /100) * self:GetParent():GetPhysicalArmorBaseValue()
	self.hp_regen = self:GetAbility():GetSpecialValueFor('bonus_hp_regen')
	self.ms = self:GetAbility():GetSpecialValueFor('reduce_ms')
	self.as = -( (self:GetAbility():GetSpecialValueFor('reduce_as')/100) * self:GetParent():GetAttackSpeed()) * 100
 
end

function modifier_ritual_buff:OnRefresh() 
	self:OnCreated()
end

 function modifier_ritual_buff:GetModifierPhysicalArmorBonus()
 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
 		return 
 	else 
 		return self.armor 
 	end
 end

 function modifier_ritual_buff:GetModifierHPRegenAmplify_Percentage()
 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
 		return 
 	else 
 		return self.hp_regen 
 	end
 end

 function modifier_ritual_buff:GetModifierMoveSpeedBonus_Constant()
 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
 		return -self.ms
 	else 
 		return   
 	end
 end

 function modifier_ritual_buff:GetModifierAttackSpeedBonus_Constant()
 	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
 		return self.as
 	else 
 		return   
 	end
 end

