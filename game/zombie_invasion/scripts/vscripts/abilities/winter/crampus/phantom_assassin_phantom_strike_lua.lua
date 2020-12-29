phantom_assassin_phantom_strike_lua = class({}) 
--------------------------------------------------------------------------------
-- Ability Cast Filter
function phantom_assassin_phantom_strike_lua:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function phantom_assassin_phantom_strike_lua:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

--------------------------------------------------------------------------------
-- Ability Start
function phantom_assassin_phantom_strike_lua:OnSpellStart()
	-- unit identifier.
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 75000000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
	local caster = self:GetCaster()
	local target = enemies[ RandomInt( 1, #enemies )]
	local origin = caster:GetOrigin()

	-- Stop if blocked by linken
 

	-- Get data
	local buff_duration = self:GetDuration()

	-- Generate data
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	-- Add modifier
 

 
end

--------------------------------------------------------------------------------
 