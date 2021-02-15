if item_shivas_guard_heal == nil then item_shivas_guard_heal = class({}) end

LinkLuaModifier("modifier_imba_shiva_active_thinker", "items/support/item_shivas", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shiva_heal_passive", "items/support/item_shivas", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shiva_heal_aura", "items/support/item_shivas", LUA_MODIFIER_MOTION_NONE)


function item_shivas_guard_heal:OnSpellStart()
	-- Parameters
 	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	caster:AddNewModifier(caster, self, "modifier_imba_shiva_active_thinker", {duration = (self:GetSpecialValueFor("blast_radius") / self:GetSpecialValueFor("blast_speed"))})

 
 
end

function item_shivas_guard_heal:GetIntrinsicModifierName()
	return "modifier_shiva_heal_passive"
end

modifier_imba_shiva_active_thinker = class({})

function modifier_imba_shiva_active_thinker:IsDebuff()			return false end
function modifier_imba_shiva_active_thinker:IsHidden() 			return true end
function modifier_imba_shiva_active_thinker:IsPurgable() 		return false end
function modifier_imba_shiva_active_thinker:IsPurgeException() 	return false end
function modifier_imba_shiva_active_thinker:RemoveOnDeath() 	return false end
function modifier_imba_shiva_active_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shiva_active_thinker:OnCreated()
	self.ability = self:GetAbility()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti8/shivas_guard_ti8_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.ability:GetSpecialValueFor("blast_radius"), self:GetDuration() * 1.33, self.ability:GetSpecialValueFor("blast_speed")))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.hitted = {}
	end
end

function modifier_imba_shiva_active_thinker:OnIntervalThink()
	local radius_increase = (self.ability:GetSpecialValueFor("blast_speed") / (1.0 / FrameTime())) * 100
	self:SetStackCount(self:GetStackCount() + radius_increase)
	local radius = self:GetStackCount() / 100
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, FrameTime(), false)
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
 

	for _, ally in pairs(allies) do
		if not self.hitted[ally:entindex()] then
			self.hitted[ally:entindex()] = true
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti8/shivas_guard_ti8_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(pfx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
            ally:Heal(self.ability:GetSpecialValueFor("heal") + (ally:GetMaxHealth() * (self.ability:GetSpecialValueFor("heal_max_hp")/100)), self:GetAbility())
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, self.ability:GetSpecialValueFor("heal") + (ally:GetMaxHealth() * (self.ability:GetSpecialValueFor("heal_max_hp")/100)), nil)
 		end
	end
end

function modifier_imba_shiva_active_thinker:OnDestroy()
	if IsServer() then
		local radius = self:GetStackCount() / 100
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, self.ability:GetSpecialValueFor("slow_duration_tooltip"), false)
		self.hitted = nil
	end
	self.ability = nil
end

modifier_shiva_heal_passive = class({})

function modifier_shiva_heal_passive:IsDebuff()			return false end
function modifier_shiva_heal_passive:IsHidden() 			return true end
function modifier_shiva_heal_passive:IsPurgable() 		return false end
function modifier_shiva_heal_passive:IsPurgeException() 	return false end
function modifier_shiva_heal_passive:RemoveOnDeath() 	return false end
function modifier_shiva_heal_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shiva_heal_passive:OnCreated()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
 	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_intellect")
 	self.aura_radius =  self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_shiva_heal_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS

	}
end

function modifier_shiva_heal_passive:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_shiva_heal_passive:GetModifierBonusStats_Intellect()
    return self.bonus_int
end

function modifier_shiva_heal_passive:IsAura() 				return true end
function modifier_shiva_heal_passive:IsAuraActiveOnDeath()	return false end

function modifier_shiva_heal_passive:GetAuraRadius()			return self.aura_radius end
function modifier_shiva_heal_passive:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_shiva_heal_passive:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_shiva_heal_passive:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO end
function modifier_shiva_heal_passive:GetModifierAura()			return "modifier_shiva_heal_aura" end

modifier_shiva_heal_aura = class({})
function modifier_shiva_heal_aura:IsHidden() return false end

function modifier_shiva_heal_aura:OnCreated()
	self.hp_regen_plus_aura = self:GetAbility():GetSpecialValueFor("hp_regen_plus_aura")
 
end

 
function modifier_shiva_heal_aura:GetTexture()
	return "item_shiva_heal"
end

function modifier_shiva_heal_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		  

	}
end

function modifier_shiva_heal_aura:GetModifierHPRegenAmplify_Percentage()  
	return self.hp_regen_plus_aura
end