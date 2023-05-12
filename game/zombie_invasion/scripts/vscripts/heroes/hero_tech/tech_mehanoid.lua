tech_mehanoid = class({})

function tech_mehanoid:OnSpellStart() 
	local caster = self:GetCaster()
	local point_for_unit = self:GetCursorPosition()
	local bonus_health = self:GetSpecialValueFor("bonus_health")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")
	local bonus_armor = self:GetSpecialValueFor("bonus_armor")
	local bonus_regen = self:GetSpecialValueFor("bonus_regen")
	local duration = self:GetSpecialValueFor("duration")
	print(caster.meh)
	if caster.meh and IsValidEntity(caster.meh) and caster.meh:IsAlive() then 
		FindClearSpaceForUnit(caster.meh, point_for_unit, true)

		caster.meh:SetBaseMaxHealth(bonus_health)
		caster.meh:SetMaxHealth(bonus_health )
		caster.meh:SetHealth(bonus_health )		
		caster.meh:SetBaseDamageMin(bonus_damage)	
		caster.meh:SetBaseDamageMax(bonus_damage)
		caster.meh:SetPhysicalArmorBaseValue(bonus_armor)
		caster.meh:SetBaseHealthRegen(bonus_regen)
	elseif caster.meh and IsValidEntity(caster.meh) and not caster.meh:IsAlive() then 
		FindClearSpaceForUnit(caster.meh, point_for_unit, true)
		caster.meh:RespawnUnit()
				caster.meh:SetBaseMaxHealth(bonus_health)
		 
		caster.meh:SetMaxHealth(bonus_health )
		caster.meh:SetHealth(bonus_health )				
		caster.meh:SetBaseDamageMin(bonus_damage)	
		caster.meh:SetBaseDamageMax(bonus_damage)
		caster.meh:SetPhysicalArmorBaseValue(bonus_armor)
		caster.meh:SetBaseHealthRegen(bonus_regen)
	else 
 
	caster.meh = CreateUnitByName("npc_mechanoid", point_for_unit, true, nil, nil, DOTA_TEAM_GOODGUYS)
 	
 	caster.meh:FindAbilityByName("mechanoid_splash"):SetLevel(1)
	caster.meh:SetOwner( caster )
	caster.meh:SetControllableByPlayer( caster:GetPlayerID(), true )
	FindClearSpaceForUnit( caster.meh, point_for_unit, true )
	caster.meh:SetBaseMaxHealth(bonus_health)
	caster.meh:SetBaseDamageMin(bonus_damage)	
	caster.meh:SetBaseDamageMax(bonus_damage)
	caster.meh:SetPhysicalArmorBaseValue(bonus_armor)
 	caster.meh:SetBaseHealthRegen(bonus_regen)

	end
end

 