LinkLuaModifier( "modifier_templar_secret", "heroes/hero_templar/queen_of_the_secret_techiques/queen_of_the_secret_techiques", LUA_MODIFIER_MOTION_NONE )



templar_secret = class({})

function templar_secret:GetIntrinsicModifierName()
    return "modifier_templar_secret"
end


modifier_templar_secret = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_secret:IsHidden()
	return true
end

function modifier_templar_secret:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_templar_secret:OnIntervalThink()
	if not IsServer() then return end
	if self:GetAbility():IsFullyCastable() then
		self:GetAbility().params.record = true
	end	
end

-- Initializations
function modifier_templar_secret:OnCreated( kv )
	-- references
	self.temp_crit_chance = self:GetAbility():GetSpecialValueFor( "temp_crit_chance" )
	self.temp_crit_mult = self:GetAbility():GetSpecialValueFor( "temp_crit_mult" )
	self.crit = false
end

function modifier_templar_secret:OnRefresh( kv )
	-- references
	self.temp_crit_chance = self:GetAbility():GetSpecialValueFor( "temp_crit_chance" )
	self.temp_crit_mult = self:GetAbility():GetSpecialValueFor( "temp_crit_mult" )
end

function modifier_templar_secret:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_templar_secret:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
				MODIFIER_PROPERTY_PROJECTILE_NAME,

	}

	return funcs
end


function modifier_templar_secret:GetModifierPreAttack_CriticalStrike( params )
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end

		-- Throw dice
		if RandomInt(0, 100)<self.temp_crit_chance then
			self.record = params.record
			return self.temp_crit_mult
		end
	
end
function modifier_templar_secret:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then

			self.record = nil
			

			-- Play effects
			local sound_cast = "Hero_TemplarAssassin.Meld.Attack"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end


function modifier_templar_secret:GetModifierProjectileName()
    return "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
end