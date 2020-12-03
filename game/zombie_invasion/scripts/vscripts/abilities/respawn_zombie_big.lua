UNIT_RESPAWN_TIME = 60

function Respoint (keys )
	Timers:CreateTimer(0.01,function()	          

		local caster = keys.caster 	--пробиваем IP усопшего
		caster.respoint = caster:GetAbsOrigin() -- определяем точку спавна
		caster.fw = caster:GetForwardVector()
	end)
end

function RespawnWeak (keys )
	local caster= keys.caster
	local caster_position = caster:GetAbsOrigin()
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local respawn_time = UNIT_RESPAWN_TIME

	Timers:CreateTimer(respawn_time,function()	
		local unit = CreateUnitByName(name, caster_position, true, nil, nil, team)
	end)
end

function RespawnStrong(keys)	

	local caster= keys.caster
	local position = caster.respoint + RandomVector( RandomFloat( 0, 20))
	local name = caster:GetUnitName()
	local team = caster:GetTeam()
	local respawn_time = UNIT_RESPAWN_TIME
	
	Timers:CreateTimer(respawn_time,function()	
	local unit = CreateUnitByName(name, position , true, nil, nil, team)
		unit:SetForwardVector(caster.fw)
	end)

end

