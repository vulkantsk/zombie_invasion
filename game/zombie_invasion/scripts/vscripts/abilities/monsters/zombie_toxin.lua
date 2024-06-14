zombie_toxin = {}

LinkLuaModifier( "modifier_zombie_toxin", "abilities/monsters/zombie_toxin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_toxin_debuff", "abilities/monsters/zombie_toxin", LUA_MODIFIER_MOTION_NONE )

function zombie_toxin:GetIntrinsicModifierName()
	return "modifier_zombie_toxin"
end

modifier_zombie_toxin = {}

function modifier_zombie_toxin:IsHidden()
	return true
end

function modifier_zombie_toxin:IsDebuff()
	return false
end

function modifier_zombie_toxin:IsPurgable()
	return false
end

function modifier_zombie_toxin:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_zombie_toxin:OnAttackLanded( params )
	if IsServer() then
		local target = params.target
		

		local stack = 0
		local modifier = target:FindModifierByNameAndCaster("modifier_zombie_toxin_debuff", self:GetAbility():GetCaster())

		if modifier==nil then
			if not self:GetParent():PassivesDisabled() then
				local duration = self:GetAbility():GetSpecialValueFor("bonus_reset_time")

				target:AddNewModifier(
					self:GetAbility():GetCaster(),
					self:GetAbility(),
					"modifier_zombie_toxin_debuff",
					{ duration = duration }
				)

				stack = 1
			end
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()

			stack = modifier:GetStackCount()
		end

		return stack * self:GetAbility():GetSpecialValueFor("damage_per_stack")
	end
end

modifier_zombie_toxin_debuff = {}

function modifier_zombie_toxin_debuff:IsHidden()
	return false
end

function modifier_zombie_toxin_debuff:IsDebuff()
	return true
end

function modifier_zombie_toxin_debuff:IsPurgable()
	return false
end

function modifier_zombie_toxin_debuff:OnCreated( kv )
	self:SetStackCount(1)
end
