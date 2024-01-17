
item_crystal_boots = item_crystal_boots or class({})
LinkLuaModifier("modifier_item_crystal_boots", "items/bots/item_crystal_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_crystal_boots_buff", "items/bots/item_crystal_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_crystal_boots_megacrit", "items/bots/item_crystal_boots", LUA_MODIFIER_MOTION_NONE)

function item_crystal_boots:GetIntrinsicModifierName()
	return "modifier_item_crystal_boots"
end

function item_crystal_boots:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "DOTA_Item.PhaseBoots.Activate"
	local modifier_boost = "modifier_imba_crystal_boots_buff"

	-- Ability specials
	local phase_duration = ability:GetSpecialValueFor("phase_duration")

	-- Emit cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add boost modifier
	caster:AddNewModifier(caster, ability, modifier_boost, {duration = phase_duration})
end


-- Stats modifier (stackable)
modifier_item_crystal_boots = modifier_item_crystal_boots or class({})

function modifier_item_crystal_boots:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_movement_speed = self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.crit_bonus = self.ability:GetSpecialValueFor("crit_multiplier")
	self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_all = self.ability:GetSpecialValueFor("bonus_all")
	
end

function modifier_item_crystal_boots:IsHidden() return true end
function modifier_item_crystal_boots:IsPurgable() return false end
function modifier_item_crystal_boots:IsDebuff() return false end
function modifier_item_crystal_boots:IsPermanent() return true end
function modifier_item_crystal_boots:RemoveOnDeath() return false end
function modifier_item_crystal_boots:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_crystal_boots:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE}

	return decFuncs
end

function modifier_item_crystal_boots:GetModifierPreAttack_CriticalStrike(keys)
    local target = keys.target

    if keys.attacker == self:GetCaster() and (target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == keys.attacker:GetTeamNumber()) then return end
 
    if self:GetCaster():HasModifier("modifier_imba_crystal_boots_megacrit") then return end

    if keys.attacker == self:GetCaster() and RollPseudoRandomPercentage(self.crit_chance, 1, self:GetCaster()) then
            return self.crit_bonus
    end
    return
end

function modifier_item_crystal_boots:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_crystal_boots:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crystal_boots:GetModifierManaBonus()
	return self.bonus_health
end

function modifier_item_crystal_boots:GetModifierBonusStats_Strength()
	return self.bonus_all
end

function modifier_item_crystal_boots:GetModifierBonusStats_Agility()
	return self.bonus_all
end

function modifier_item_crystal_boots:GetModifierBonusStats_Intellect()
	return self.bonus_all
end

function modifier_item_crystal_boots:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crystal_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self.bonus_movement_speed
end


-- Move speed bonus buff (active)
modifier_imba_crystal_boots_buff = modifier_imba_crystal_boots_buff or class({})

function modifier_imba_crystal_boots_buff:IsHidden() return false end
function modifier_imba_crystal_boots_buff:IsPurgable() return false end
function modifier_imba_crystal_boots_buff:IsDebuff() return false end

function modifier_imba_crystal_boots_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_boost = "particles/item/boots/haste_boots_speed_boost.vpcf"
	self.particle_drain = "particles/item/boots/haste_boots_drain.vpcf"

	-- Ability specials
	self.phase_ms = self.ability:GetSpecialValueFor("phase_ms")
	self.ms_limit = self.ability:GetSpecialValueFor("ms_limit")
	self.en_num = self.ability:GetSpecialValueFor("en_num")

	if IsServer() then

        self:SetStackCount(self.en_num)
		-- Apply particle effects
		local particle_boost_fx = ParticleManager:CreateParticle(self.particle_boost, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle_boost_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_boost_fx, 1, self.caster:GetAbsOrigin())
		self:AddParticle(particle_boost_fx, false, false, -1, false, false)

		-- Set table for drained units
		self.drained_units = {}
        self.up_crit = 0
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_crystal_boots_buff:OnIntervalThink()
	if IsServer() then
		-- Look for nearby enemies in drain radius
        if self.up_crit == 1 then return end
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			90,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Damage enemies and suck health
		for _,enemy in ipairs(enemies) do
			-- If the enemy was already drained, do nothing
			if not self.drained_units[enemy:entindex()] then

 
                self:DecrementStackCount()
				-- Add drain particle
				local particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(particle_drain_fx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_drain_fx)
 

				-- Add enemy to the table
				self.drained_units[enemy:entindex()] = enemy:entindex()
			end
		end

		if self:GetStackCount() <= 0 then 
			self.caster:AddNewModifier(self.caster,self.ability,"modifier_imba_crystal_boots_megacrit",{duration = 10})
			self.up_crit = 1
	    end
	end
end

function modifier_imba_crystal_boots_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return decFuncs
end

function modifier_imba_crystal_boots_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.phase_ms
end

function modifier_imba_crystal_boots_buff:GetModifierIgnoreMovespeedLimit()  
	return 1
end

function modifier_imba_crystal_boots_buff:GetModifierMoveSpeed_Limit()  
	return self.ms_limit
end

function modifier_imba_crystal_boots_buff:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end

 
modifier_imba_crystal_boots_megacrit = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
            MODIFIER_EVENT_ON_ATTACK_LANDED
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_imba_crystal_boots_megacrit:OnRefresh()
    self:OnCreated()
end

function modifier_imba_crystal_boots_megacrit:OnCreated()
    self.crit_bonus_up = self:GetAbility():GetSpecialValueFor("crit_bonus_up")
    self.crit = false 
end

function modifier_imba_crystal_boots_megacrit:GetModifierPreAttack_CriticalStrike(keys)
    local target = keys.target
    self.crit = false 
    if keys.attacker == self:GetCaster() and (target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == keys.attacker:GetTeamNumber()) then return end
 
 
    if keys.attacker == self:GetCaster()  then
        self.crit = true

        return self.crit_bonus_up
 
    end
    
    return
 
end

function modifier_imba_crystal_boots_megacrit:OnAttackLanded(keys)
    local target = keys.target
    if self:GetCaster() == keys.attacker then
        if self.crit then
            EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_PhantomAssassin.CoupDeGrace", self:GetCaster())
            
             
            local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt(fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            ParticleManager:SetParticleControl(fx, 1, target:GetAbsOrigin())
            ParticleManager:SetParticleControlOrientation(fx, 1, self:GetCaster():GetForwardVector() * (-1), self:GetCaster():GetRightVector(), self:GetParent():GetUpVector())
            ParticleManager:ReleaseParticleIndex(fx)

            self:GetCaster():RemoveModifierByName("modifier_imba_crystal_boots_megacrit")
        end
    end
end

 
function modifier_imba_crystal_boots_megacrit:GetTexture()
	return "phantom_assassin_coup_de_grace"
end