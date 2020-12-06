LinkLuaModifier("modifier_techies_taunt", "abilities/endgame/techies_taunt", 0)

techies_taunt=class({})

function techies_taunt:GetIntrinsicModifierName()
	return "modifier_techies_taunt"
end

function techies_taunt:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("techies_tech_levelup_0"..RandomInt(1, 9))
--	target:EmitSound("Hero_Techies.ProjectileImpact")

	local effect = "particles/units/heroes/hero_techies/techies_base_attack.vpcf"
	caster:StartGestureWithPlaybackRate(ACT_DOTA_TAUNT, 1.5)
end

modifier_techies_taunt = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}end,
})

function modifier_techies_taunt:GetActivityTranslationModifiers()
	return "swing_around_gesture"
end
