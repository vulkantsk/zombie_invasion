function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

 	hSpawner = Entities:FindByName( nil, "final_point" )
    
    local modif = thisEntity:FindModifierByName("modifier_nevermore_necromastery")
    modif:SetStackCount(20)
    didBlink = false

	hSfBlinkAbility = thisEntity:FindAbilityByName( "sf_blink" )  
	hSfshadowAbility1 = thisEntity:FindAbilityByName( "sf_shadowraze1" )  
	hSfshadowAbility2 = thisEntity:FindAbilityByName( "sf_shadowraze2" )  
	hSfshadowAbility3 = thisEntity:FindAbilityByName( "sf_shadowraze3" )  
	hSfRequiemAbility = thisEntity:FindAbilityByName( "sf_requiem" )  
	thisEntity:SetContextThink( "SfThink", SfThink, 1 )
end

function SfThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false or thisEntity:HasModifier("modifier_invulnerable") then
		return 1
	end
	
	local npc = thisEntity
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	local enemy = enemies[1]
	
	if #enemies == 0 then
 
			MoveToTarget()
  
 
	else 
        if hSfRequiemAbility:IsFullyCastable() then 
        	if hSfBlinkAbility:IsFullyCastable() then 
        		CastBlink( enemies[ RandomInt( 1, #enemies ) ] )
        		Timers:CreateTimer(0.5,function()
                    CastAbility(hSfRequiemAbility)
                end)
        	end 

        else
        	AttackMove( npc, enemy )
        end



	end	

	return 1.0	
end

function CastAbility(ability)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:entindex(),
	})

	return 1.00
end

function CastBlink( enemy )
	didBlink = true
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hSfBlinkAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end


function AttackMove( unit, enemy )
	if enemy == nil then
		return
	end
--	print("ATTACK MOVE")
	ExecuteOrderFromTable({
		UnitIndex = unit:entindex(),				--индекс кастера
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,	-- тип приказа атака
		Position = enemy:GetOrigin(),				-- пощиция врага
		Queue = false,
	})

	return 1
end
 

function MoveToTarget()
	if hSpawner == nil then
		print ( "Lycan doesn't know where target is" )
		return
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetOrigin()
	})
	return 1
end

 