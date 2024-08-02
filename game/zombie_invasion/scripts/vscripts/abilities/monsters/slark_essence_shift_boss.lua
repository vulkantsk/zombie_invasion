slark_essence_shift_boss = class({})
LinkLuaModifier( "modifier_slark_essence_shift_boss", "abilities/monsters/slark_essence_shift_boss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_essence_shift_boss_debuff", "abilities/monsters/slark_essence_shift_boss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_essence_shift_boss_stack", "abilities/monsters/slark_essence_shift_boss", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function slark_essence_shift_boss:GetIntrinsicModifierName()
	return "modifier_slark_essence_shift_boss"
end

modifier_slark_essence_shift_boss = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE} end,
})

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_boss:OnCreated( kv )
	-- references
	self.damage_gain = self:GetAbility():GetSpecialValueFor( "damage_gain" )
	self.speed_gain = self:GetAbility():GetSpecialValueFor( "speed_gain" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_slark_essence_shift_boss:OnRefresh( kv )
	-- references
	self.damage_gain = self:GetAbility():GetSpecialValueFor( "damage_gain" )
	self.speed_gain = self:GetAbility():GetSpecialValueFor( "speed_gain" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end


 


function modifier_slark_essence_shift_boss:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		-- filter enemy
		local target = params.target
		if (not target:IsHero()) or target:IsIllusion() then
			return
		end

		-- Apply debuff to enemy
		local debuff = params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_slark_essence_shift_boss_debuff",
			{
				stack_duration = self.duration,
				duration = self.duration
			}
		)

		-- Apply buff to self
		self:AddStack( duration )

		-- Play effects
		self:PlayEffects( params.target )
	end
end

function modifier_slark_essence_shift_boss:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.speed_gain
end

function modifier_slark_essence_shift_boss:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount() * self.damage_gain
end
--------------------------------------------------------------------------------
-- Helper
function modifier_slark_essence_shift_boss:AddStack( duration )
	-- Add counter
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_slark_essence_shift_boss_stack",
		{
			duration = self.duration,
		}
	)
	mod.modifier = self

	-- Add stack
	self:IncrementStackCount()
end

function modifier_slark_essence_shift_boss:RemoveStack()
	self:DecrementStackCount()
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_essence_shift_boss:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_slark_essence_shift_boss_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_boss_debuff:IsHidden()
	return false
end

function modifier_slark_essence_shift_boss_debuff:IsDebuff()
	return true
end

function modifier_slark_essence_shift_boss_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_boss_debuff:OnCreated( kv )
	-- references
	self.stat_loss = self:GetAbility():GetSpecialValueFor( "stat_loss" )
	self.duration = kv.stack_duration

	if IsServer() then
		self:AddStack( self.duration )
	end
end

function modifier_slark_essence_shift_boss_debuff:OnRefresh( kv )
	-- references
	self.stat_loss = self:GetAbility():GetSpecialValueFor( "stat_loss" )
	self.duration = kv.stack_duration

	if IsServer() then
		self:AddStack( self.duration )
	end
end

function modifier_slark_essence_shift_boss_debuff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_essence_shift_boss_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_slark_essence_shift_boss_debuff:GetModifierBonusStats_Strength()
	return self:GetStackCount() * -self.stat_loss
end
function modifier_slark_essence_shift_boss_debuff:GetModifierBonusStats_Agility()
	return self:GetStackCount() * -self.stat_loss
end
function modifier_slark_essence_shift_boss_debuff:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * -self.stat_loss
end

--------------------------------------------------------------------------------
-- Helper
function modifier_slark_essence_shift_boss_debuff:AddStack( duration )
	-- Add modifier
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_slark_essence_shift_boss_stack",
		{
			duration = self.duration,
		}
	)
	mod.modifier = self

	-- Add stack
	self:IncrementStackCount()
end

function modifier_slark_essence_shift_boss_debuff:RemoveStack()
	self:DecrementStackCount()

	if self:GetStackCount()<=0 then
		self:Destroy()
	end
end

modifier_slark_essence_shift_boss_stack = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_essence_shift_boss_stack:IsHidden()
	return true
end

function modifier_slark_essence_shift_boss_stack:IsPurgable()
	return false
end
function modifier_slark_essence_shift_boss_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_essence_shift_boss_stack:OnCreated( kv )
end

function modifier_slark_essence_shift_boss_stack:OnRemoved()
	if IsServer() then
		self.modifier:RemoveStack()
	end
end