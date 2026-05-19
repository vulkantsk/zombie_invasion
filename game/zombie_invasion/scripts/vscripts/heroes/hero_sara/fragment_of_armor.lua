sara_fragment_of_armor = class({})

function sara_fragment_of_armor:Precache(context)
	PrecacheAbilityResources({
		"particles/arena/units/heroes/hero_sara/fragment_of_armor.vpcf",
	}, {
		"Hero_Medusa.ManaShield.Off",
		"Hero_Medusa.ManaShield.On",
		"Hero_Medusa.ManaShield.Proc",
	}, context)
end

LinkLuaModifier("modifier_sara_fragment_of_armor", "heroes/hero_sara/fragment_of_armor.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	function sara_fragment_of_armor:OnToggle()
		local caster = self:GetCaster()
		if self:GetToggleState() then
			caster:AddNewModifier(caster, self, "modifier_sara_fragment_of_armor", nil)
		else
			caster:RemoveModifierByName("modifier_sara_fragment_of_armor")
		end
	end
end

function sara_fragment_of_armor:OnUpgrade()
    local modifier = self:GetCaster():FindModifierByName( "modifier_sara_fragment_of_armor" )

    if modifier then
        modifier:ForceRefresh()
    end
end

modifier_sara_fragment_of_armor = class({
	IsHidden = function() return false end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	GetEffectName = function() return "particles/arena/units/heroes/hero_sara/fragment_of_armor.vpcf" end,
})


function modifier_sara_fragment_of_armor:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

if IsServer() then
	function modifier_sara_fragment_of_armor:OnTakeDamage(keys)
		local unit = self:GetParent()
		local ability = self:GetAbility()
		if unit == keys.unit and
			IsValidEntity(ability) and
			unit:IsAlive() and
			not unit:IsIllusion() and
			unit:HasScepter() and
			not unit:PassivesDisabled() and
			unit.GetEnergy and
			ability:GetToggleState() and
			unit:GetEnergy() >= (keys.damage * ability:GetSpecialValueFor("blocked_damage_pct") * 0.01) / ability:GetSpecialValueFor("damage_per_energy")  then
			SimpleDamageReflect(unit, keys.attacker, keys.damage * ability:GetSpecialValueFor("reflected_damage_pct_scepter") * 0.01, keys.damage_flags, self, keys.damage_type)
		end
	end
end

function modifier_sara_fragment_of_armor:OnCreated( kv )
    self.damage_per_mana = self:GetAbility():GetSpecialValueFor( "damage_per_energy" )
    self.absorb_pct = self:GetAbility():GetSpecialValueFor( "blocked_damage_pct" ) / 100

    if not IsServer() then return end

    EmitSoundOn( "Hero_Medusa.ManaShield.On", self:GetParent() )
end

function modifier_sara_fragment_of_armor:OnRefresh( kv )
    self.damage_per_mana = self:GetAbility():GetSpecialValueFor( "damage_per_energy" )
    self.absorb_pct = self:GetAbility():GetSpecialValueFor( "blocked_damage_pct" )  
end

function modifier_sara_fragment_of_armor:OnDestroy()
    if not IsServer() then return end

    EmitSoundOn( "Hero_Medusa.ManaShield.Off", self:GetParent() )
end

function modifier_sara_fragment_of_armor:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_sara_fragment_of_armor:GetModifierIncomingDamage_Percentage( params )
    local absorb = -100*self.absorb_pct
    local damage_absorbed = params.damage * self.absorb_pct
    local manacost = damage_absorbed/self.damage_per_mana
    local mana = self:GetParent():GetMana()

    if mana<manacost then
        damage_absorbed = mana * self.damage_per_mana
        absorb = -damage_absorbed/params.damage*100

        manacost = mana
    end
    self:GetParent():SpendMana( manacost, self:GetAbility() )
    EmitSoundOn( "Hero_Medusa.ManaShield.Proc", self:GetParent() )
    return absorb
end