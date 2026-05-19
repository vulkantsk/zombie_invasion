 LinkLuaModifier( "modifier_pohela_buff", "heroes/hero_yuki-onna/pohela", LUA_MODIFIER_MOTION_NONE )
 LinkLuaModifier( "modifier_pohela_debuff", "heroes/hero_yuki-onna/pohela", LUA_MODIFIER_MOTION_NONE )


yuki_pohela = class({})

function yuki_pohela:Precache(context)
	PrecacheAbilityResources({
		"particles/generic_gameplay/generic_slowed_cold.vpcf",
		"particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf",
	}, {
		"hero_Crystal.frostbite",
	}, context)
end

function yuki_pohela:OnSpellStart()
 	local target = self:GetCursorTarget()
 
	target:AddNewModifier( self:GetCaster(), self, "modifier_pohela_buff", { duration = self:GetChannelTime() } )
 	EmitSoundOn( 'hero_Crystal.frostbite', target )
end


--------------------------------------------------------------------------------

function yuki_pohela:OnChannelFinish( bInterrupted )
	 	local target = self:GetCursorTarget()

	if target ~= nil then
		target:RemoveModifierByName( "modifier_pohela_buff" )
		 StopSoundOn( 'hero_Crystal.frostbite', target )

	end
end

modifier_pohela_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        	MODIFIER_EVENT_ON_ATTACK_LANDED,
        } end,
    GetEffectName = function() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end,

})
 
function modifier_pohela_buff:OnCreated() 
	self.parent = self:GetParent()
end 
function modifier_pohela_buff:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("bonus_resistance")
end

function modifier_pohela_buff:OnAttackLanded(data)
    if data.target ~= self.parent  then return end
    if data.attacker == self.parent then return end
     
 	print('32')
 	data.attacker:AddNewModifier(self.parent,self:GetAbility(),"modifier_pohela_debuff", { duration = self:GetAbility():GetSpecialValueFor("debuff_duration")})
end 


modifier_pohela_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
    DeclareFunctions        = function(self) return 
        {
        	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        } end,
    GetEffectName = function() return "particles/generic_gameplay/generic_slowed_cold.vpcf" end,

})


function modifier_pohela_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("reduce_atack_speed")
end
