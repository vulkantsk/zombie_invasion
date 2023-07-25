function multiple_attacks_6(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if caster.__hanadayousei_lock ~= true and caster:IsRangedAttacker() then --是否远程攻击
		caster.__hanadayousei_lock = true
		local targets = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,caster:GetOrigin(),nil,800,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,FIND_CLOSEST,false)
		local count = 0
		for i=1,#targets do
			local unit = targets[i]
			if unit~=nil and unit:IsNull()==false and unit~=target and unit:IsAlive() then
				caster:PerformAttack(unit,true,false,true,false,true,false,true)
				count = count + 1
			end
			if count > 5 then
				break
			end
		end
		caster.__hanadayousei_lock = false
	end
end