function flag_value( a, b )
	return a == 0 and b or a
end

function find_units_by_ability( ability )
	local caster = ability:GetCaster()
	local range = ability:GetCastRange( caster:GetAbsOrigin(), nil )

	if not range or range <= 0 then
		return
	end

	return FindUnitsInRadius(
		caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil,
		range,
		flag_value( ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ),
		flag_value( ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ),
		ability:GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false
	)
end

function cast_ability( ability )
	if not ability or not ability:IsFullyCastable() then
		return
	end

	local caster = ability:GetCaster()
	local behavior = tonumber( tostring( ability:GetBehavior() ) )
	local castPoint = ability:GetCastPoint() + 0.3

	if has_behavior( behavior, DOTA_ABILITY_BEHAVIOR_AUTOCAST ) then
		if not ability:GetAutoCastState() then
			ability:ToggleAutoCast()
		end
	end

	if has_behavior( behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE ) then
		return
	elseif has_behavior( behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) then
		local units = find_units_by_ability( ability )

		if units then
			if #units > 0 then
				caster:CastAbilityNoTarget( ability, -1 )
				return castPoint
			end
		else
			caster:CastAbilityNoTarget( ability, -1 )
			return castPoint
		end
	elseif has_behavior( behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) then
		local units = find_units_by_ability( ability )

		if units and #units > 0 then
			caster:CastAbilityOnTarget( units[1], ability, -1 )
			return castPoint
		end
	elseif has_behavior( behavior, DOTA_ABILITY_BEHAVIOR_POINT ) then
		local units = find_units_by_ability( ability )

		if units and #units > 0 then
			caster:CastAbilityOnPosition( units[1]:GetAbsOrigin(), ability, -1 )
			return castPoint
		end
	elseif has_behavior( behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE ) then
		if not ability:GetToggleState() then
			caster:CastAbilityToggle( ability, -1 )
			return 0.2
		end
	end
end

function generic_ai( unit, abilities )
	if unit:IsChanneling() then
		return 0.2
	end

	if not abilities then
		abilities = {}

		local ins = 1
		for i = 0, 31 do
			local ability = unit:GetAbilityByIndex( i )

			if ability then
				abilities[ins] = ability
				ins = ins + 1
			end
		end
	end

	for _, ability in pairs( abilities ) do
		local time = cast_ability( ability )

		if time then
			if unit:IsRealHero() then
				print( "kekw", time )
			end

			return time
		end
	end

	for i = 0, 31 do
		local item = unit:GetItemInSlot( i )
		local time = cast_ability( item )

		if time then
			return time
		end
	end

	return 0.1
end

function has_behavior( behavior, has )
	return bit.band( behavior, has ) == has
end

function cast_ability_position( ability, pos )
	ability:GetCaster():CastAbilityOnPosition( pos, ability, -1 )
end