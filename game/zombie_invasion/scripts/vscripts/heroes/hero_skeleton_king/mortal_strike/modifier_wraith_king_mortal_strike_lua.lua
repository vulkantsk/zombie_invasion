modifier_wraith_king_mortal_strike_lua = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_wraith_king_mortal_strike_lua:IsHidden()
	return self:GetStackCount()==0
end

function modifier_wraith_king_mortal_strike_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_wraith_king_mortal_strike_lua:OnCreated( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) -- special value
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" ) -- special value
 
 
end

function modifier_wraith_king_mortal_strike_lua:OnRefresh( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) -- special value
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" ) -- special value
 
end

 

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_wraith_king_mortal_strike_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_wraith_king_mortal_strike_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			pass = true
		end

		if pass and self:RollChance(self.crit_chance) then
			self.attack_record = params.record
			-- Check condition for instakill
           return self.crit_mult
		end
	end
	return 0
end
function modifier_wraith_king_mortal_strike_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- filter
		local pass = false
		if self.attack_record and params.record==self.attack_record then
			pass = true
			self.attack_record = nil
		end

		-- logic
		if pass then
			self:PlayEffects( params.target )

			if self.instaKill then
				self.instaKill = false
				params.target:Kill( self:GetAbility(), self:GetParent() )
			end
		end
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wraith_king_mortal_strike_lua:PlayEffects( target )
	-- get resource
 
	local sound_impact = "Hero_SkeletonKing.CriticalStrike"

	-- play effect
	 local effect_impact = ParticleManager:CreateParticle( particle_impact, PATTACH_ABSORIGIN_FOLLOW, target )
	-- -- todo: find correct particle control
 

	-- play sound
	EmitSoundOn( sound_impact, target )
end

--------------------------------------------------------------------------------
-- Helper function
function modifier_wraith_king_mortal_strike_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end
 