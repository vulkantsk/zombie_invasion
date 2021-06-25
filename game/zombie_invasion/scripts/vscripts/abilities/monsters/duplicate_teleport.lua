

if duplicate_teleport == nil then
    duplicate_teleport = class({})
end


function duplicate_teleport:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end


function duplicate_teleport:GetAbilityDamageType()	
	return DAMAGE_TYPE_MAGICAL
end

function duplicate_teleport:OnSpellStart()
	if self:GetCaster() then
		self.caster = self:GetCaster()

		local enemyHeroes = nil
		local enemyCount = 0

		if GetMapName() == "chapter_two_normal" then
			enemyCount = 1
		else
			enemyHeroes = FindUnitsInRadius( self.caster:GetTeamNumber(), SPAWNER_OW_POINT, self.caster, 1200,
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
			enemyCount = #enemyHeroes
		end
		
		if enemyCount > 0 then
			local point = Entities:FindByName( nil, "otherkin_world_point_" .. RandomInt(1, 8)):GetAbsOrigin()
			local unit = CreateUnitByName("duplicate_cursed_flame", self.caster:GetAbsOrigin(), true, nil, nil, self.caster:GetTeamNumber() )
			unit:CreatureLevelUp(MINIONS_LEVEL - 1)
			self.caster:SetAbsOrigin(point)
			FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), true)
		end
	end
end





