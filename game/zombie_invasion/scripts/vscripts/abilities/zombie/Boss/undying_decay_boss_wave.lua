LinkLuaModifier( "modifier_undying_stack_debuff", "abilities/zombie/Boss/undying_decay_boss_wave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undying_stack_buff", "abilities/zombie/Boss/undying_decay_boss_wave", LUA_MODIFIER_MOTION_NONE )
undying_decay_boss_wave = class({})
undying_decay_boss_wave_2 = class({})
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function undying_decay_boss_wave:OnSpellStart()
 
	local caster        =   self:GetCaster()
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/units/heroes/hero_undying/undying_decay.vpcf"

	-- Emit sound
	caster:EmitSound("Hero_Undying.Decay.Cast")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(caster:GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		0,
		FIND_ANY_ORDER,
		false)

 
	local StackModifier = "modifier_undying_stack_buff"
 

		local currentStacks = caster:GetModifierStackCount(StackModifier, self)

		if currentStacks == 0 then
			caster:AddNewModifier(caster, self, StackModifier, {})
			caster:SetModifierStackCount(StackModifier, self, (currentStacks + #enemies))
		else 

			caster:SetModifierStackCount(StackModifier, self, (currentStacks + #enemies))
		--	caster:CalculateStatBonus( true )
		end

 
	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff.
		   if not enemy:HasModifier("modifier_undying_stack_debuff") then
                enemy:AddNewModifier(caster, self, "modifier_undying_stack_debuff",  {duration = self:GetSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance())})
                 enemy:FindModifierByName("modifier_undying_stack_debuff"):IncrementStackCount()

	DealDamage(self:GetCaster(), enemy, 100, DAMAGE_TYPE_MAGICAL, nil, self)
           else
                enemy:FindModifierByName("modifier_undying_stack_debuff"):IncrementStackCount()
                enemy:FindModifierByName("modifier_undying_stack_debuff"):SetDuration(self:GetSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance()), true)
	DealDamage(self:GetCaster(), enemy, 100, DAMAGE_TYPE_MAGICAL, nil, self)
           end
         
	end

end 

function undying_decay_boss_wave:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function undying_decay_boss_wave_2:OnSpellStart()
 
	local caster        =   self:GetCaster()
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/units/heroes/hero_undying/undying_decay.vpcf"

	-- Emit sound
	caster:EmitSound("Hero_Undying.Decay.Cast")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(caster:GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		0,
		FIND_ANY_ORDER,
		false)

 
	local StackModifier = "modifier_undying_stack_buff"
 

		local currentStacks = caster:GetModifierStackCount(StackModifier, self)

		if currentStacks == 0 then
			caster:AddNewModifier(caster, self, StackModifier, {})
			caster:SetModifierStackCount(StackModifier, self, (currentStacks + #enemies))
		else 

			caster:SetModifierStackCount(StackModifier, self, (currentStacks + #enemies))
		--	caster:CalculateStatBonus( true )
		end

 
	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff.
		   if not enemy:HasModifier("modifier_undying_stack_debuff") then
                enemy:AddNewModifier(caster, self, "modifier_undying_stack_debuff",  {duration = self:GetSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance())})
                 enemy:FindModifierByName("modifier_undying_stack_debuff"):IncrementStackCount()

	DealDamage(self:GetCaster(), enemy, 100, DAMAGE_TYPE_MAGICAL, nil, self)
           else
                enemy:FindModifierByName("modifier_undying_stack_debuff"):IncrementStackCount()
                enemy:FindModifierByName("modifier_undying_stack_debuff"):SetDuration(self:GetSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance()), true)
	DealDamage(self:GetCaster(), enemy, 100, DAMAGE_TYPE_MAGICAL, nil, self)
           end
         
	end

end 

function undying_decay_boss_wave_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_undying_stack_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_stack_buff:IsHidden()
	return false
end

function modifier_undying_stack_buff:IsDebuff()
	return false
end
 
function modifier_undying_stack_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_undying_stack_buff:OnCreated( kv )
	-- references
  self.steal_damage = self:GetAbility():GetSpecialValueFor("steal_damage")
  self.str_steal =  self:GetAbility():GetSpecialValueFor("str_steal")
  self.str_health_up =  self:GetAbility():GetSpecialValueFor("str_health_up")
     self:StartIntervalThink( 0.1 )

end
 

 function modifier_undying_stack_buff:OnRefresh( kv )
	-- references
	self:OnCreated()
 
 end
 
  function modifier_undying_stack_buff:OnIntervalThink()
 
 
     self:GetParent():CalculateGenericBonuses()
	 
end

   function modifier_undying_stack_buff:GetTexture()
return "undying_decay"
end


--------------------------------------------------------------------------------
-- Interval Effects
 

function modifier_undying_stack_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end

function modifier_undying_stack_buff:GetModifierBaseAttack_BonusDamage()
	return  (self.steal_damage * self.str_steal) * self:GetStackCount()
end

function modifier_undying_stack_buff:GetModifierExtraHealthBonus()
	return (self.str_steal * self.str_health_up)  * self:GetStackCount() 
end

function modifier_undying_stack_buff:GetModifierModelScale()
	return 4  * self:GetStackCount() 
end

 
 

--------------------------------------------------------------------------------
-- Aura Effects
 
 modifier_undying_stack_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_stack_debuff:IsHidden()
	return false
end

function modifier_undying_stack_debuff:IsDebuff()
	return true
end

function modifier_undying_stack_debuff:IsStunDebuff()
	return false
end

function modifier_undying_stack_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_undying_stack_debuff:OnCreated( kv )
	-- references
 
  	self:StartIntervalThink( 0.1 )

end

 function modifier_undying_stack_debuff:OnIntervalThink()

 
      self:GetParent():CalculateStatBonus(true)
	 
end
 


--------------------------------------------------------------------------------
-- Interval Effects
 

function modifier_undying_stack_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_undying_stack_debuff:GetModifierBonusStats_Strength()
	return -( self:GetAbility():GetSpecialValueFor("str_steal") * self:GetStackCount())
end