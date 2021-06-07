LinkLuaModifier(
	"modifier_portal_wd_zombie_invul",
	"modifiers/modifier_portal_wd_zombie_invul",
	LUA_MODIFIER_MOTION_NONE
)

local team = thisEntity:GetTeam()

local function Think()
	if GameRules:IsGamePaused() then
		return
	end

	if thisEntity:IsChanneling() then
		return
	end

	local pos = thisEntity:GetAbsOrigin()
	local heal = thisEntity:FindAbilityByName( "invasion_portal_wd_heal" )
	local maledict = thisEntity:FindAbilityByName( "invasion_portal_wd_maledict" )
	local deathWard = thisEntity:FindAbilityByName( "invasion_portal_wd_death_ward" )

	if not heal or not maledict or not deathWard then
		return
	end

	if not heal:GetToggleState() then
		heal:ToggleAbility()
		return
	end

	local attack = false

	if not thisEntity.zombie or thisEntity.zombie:IsNull() or not thisEntity.zombie:IsAlive() then
		attack = true
		thisEntity.zombie = nil
	elseif not thisEntity.zombie:HasModifier( "modifier_portal_wd_zombie_invul" ) then
		attack = true
	else
		local zombiePos = thisEntity.zombie:GetAbsOrigin()
		local diff = pos - zombiePos
		local zombieRange = diff:Length2D()
		diff.z = 0

		if zombieRange >= ( heal:GetSpecialValueFor( "radius" ) or 0 ) then
			thisEntity:MoveToPosition( zombiePos + diff:Normalized() * 300 )
		end
	end

	enemies = FindUnitsInRadius(
		team,
		pos,
		nil,
		600,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST,
		false
	)

	target = enemies[1]

	if not target then
		if attack and not thisEntity:GetAttackTarget() then
			thisEntity:MoveToPositionAggressive( Entities:FindByName( nil, "final_point" ):GetAbsOrigin() )

			return 0.9
		end

		return
	end

	local targetPos = target:GetAbsOrigin()

	if maledict:IsFullyCastable() then
		thisEntity:CastAbilityOnPosition( targetPos, maledict, -1 )
		return 0.5
	end

	if deathWard:IsFullyCastable() then
		thisEntity:CastAbilityOnPosition( targetPos, deathWard, -1 )
		return 0.5
	end
end

function Spawn( data )
	Timers:CreateTimer( 0, function()
		if not thisEntity or thisEntity:IsNull() or not thisEntity:IsAlive() then
			return
		end

		zombie = CreateUnitByName(
			"npc_invasion_portal_wd_zombie",
			thisEntity:GetAbsOrigin() + RandomVector( 120 ),
			true,
			nil,
			nil,
			team
		)
		zombie:SetHealth( zombie:GetMaxHealth() * 0.2 )
		zombie:AddNewModifier( thisEntity, nil, "modifier_portal_wd_zombie_invul", nil )
		thisEntity.zombie = zombie

		ZSpawn:InitUnit( zombie )

		thisEntity:SetContextThink( "", function()
			return Think() or 0.3
		end, 0.1 )
	end )
end