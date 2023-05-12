tech_mehanoid_attack = class({})

function tech_mehanoid_attack:OnSpellStart() 
	local caster = self:GetCaster()
	local point_for_unit = self:GetCursorPosition()
	local bonus_health = self:GetSpecialValueFor("bonus_health")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")
	local duration = self:GetSpecialValueFor("duration")

	if caster.mehAttack and IsValidEntity(caster.mehAttack) and caster.mehAttack:IsAlive() then 
		FindClearSpaceForUnit(caster.mehAttack, point_for_unit, true)

		caster.mehAttack:SetBaseMaxHealth(bonus_health)
		caster.mehAttack:SetBaseDamageMin(bonus_damage)	
		caster.mehAttack:SetBaseDamageMax(bonus_damage)
	elseif caster.mehAttack and IsValidEntity(caster.mehAttack) and not caster.mehAttack:IsAlive() then 
		FindClearSpaceForUnit(caster.mehAttack, point_for_unit, true)
		caster.mehAttack:RespawnUnit()
	else 
	caster.mehAttack = CreateUnitByName("npc_mechanoid_attack", point_for_unit, true, nil, nil, DOTA_TEAM_GOODGUYS)
 
	caster.mehAttack:SetOwner( caster )
	caster.mehAttack:SetControllableByPlayer( caster:GetPlayerID(), true )
	FindClearSpaceForUnit( caster.mehAttack, point_for_unit, true )
	caster.mehAttack:SetBaseMaxHealth(bonus_health)
	caster.mehAttack:SetBaseDamageMin(bonus_damage)	
	caster.mehAttack:SetBaseDamageMax(bonus_damage)
	end
end

 