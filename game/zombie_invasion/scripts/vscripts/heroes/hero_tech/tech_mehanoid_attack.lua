tech_mehanoid_attack = class({})

function tech_mehanoid_attack:OnSpellStart() 
	local caster = self:GetCaster()
	local point_for_unit = self:GetCursorPosition()
	local bonus_health = self:GetSpecialValueFor("bonus_health")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")
	local attack_time = self:GetSpecialValueFor("attack_time")
	local ability = self
	local duration = self:GetSpecialValueFor("duration")

	if caster.mehAttack and IsValidEntity(caster.mehAttack) and caster.mehAttack:IsAlive() then 
		FindClearSpaceForUnit(caster.mehAttack, point_for_unit, true)

		caster.mehAttack:SetBaseMaxHealth(bonus_health)

		caster.mehAttack:SetMaxHealth(bonus_health )
		caster.mehAttack:SetHealth(bonus_health )		
		caster.mehAttack:SetBaseDamageMin(bonus_damage)	
		caster.mehAttack:SetBaseDamageMax(bonus_damage)
		caster.mehAttack:SetTimeUntilRespawn(-1)
		caster.mehAttack:RespawnUnit()
	elseif caster.mehAttack and IsValidEntity(caster.mehAttack) and not caster.mehAttack:IsAlive() then 
		FindClearSpaceForUnit(caster.mehAttack, point_for_unit, true)
		caster.mehAttack:RespawnUnit()
			caster.mehAttack:SetBaseMaxHealth(bonus_health)
					caster.mehAttack:SetMaxHealth(bonus_health )
		caster.mehAttack:SetHealth(bonus_health )	
	caster.mehAttack:SetBaseDamageMin(bonus_damage)	
	caster.mehAttack:SetBaseDamageMax(bonus_damage)
	caster.mehAttack:SetUnitCanRespawn(true)
	else 
	caster.mehAttack = CreateUnitByName("npc_mechanoid_attack", point_for_unit, true, nil, caster, caster:GetTeamNumber())
 
	caster.mehAttack:SetOwner( caster )
	caster.mehAttack:SetControllableByPlayer( caster:GetPlayerID(), true )
	FindClearSpaceForUnit( caster.mehAttack, point_for_unit, true )
	caster.mehAttack:SetBaseMaxHealth(bonus_health)
	caster.mehAttack:SetBaseDamageMin(bonus_damage)	
	caster.mehAttack:SetBaseDamageMax(bonus_damage)
	caster.mehAttack:RespawnUnit()
	end
end

 