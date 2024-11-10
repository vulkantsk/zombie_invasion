--[[ ============================================================================================================
	Author: Rook, with help from Noya
	Date: February 2, 2015
	Returns a reference to a newly-created illusion unit.
================================================================================================================= ]]
function create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	local player_id = keys.caster:GetPlayerID()
	local caster_team = keys.caster:GetTeam()
	
	-- Создаем иллюзию
	local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, keys.caster, caster_team)
	illusion:SetPlayerID(player_id)
	illusion:SetControllableByPlayer(player_id, true)

	-- Поднимаем уровень иллюзии до уровня героя
	local caster_level = keys.caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	-- Копируем способности героя
	illusion:SetAbilityPoints(0)
	for ability_slot = 0, 15 do
		local individual_ability = keys.caster:GetAbilityByIndex(ability_slot)
		if individual_ability then 
			local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
			if illusion_ability then
				illusion_ability:SetLevel(individual_ability:GetLevel())
			end
		end
	end

	-- Копируем предметы героя
	for item_slot = 0, 5 do
		local individual_item = keys.caster:GetItemInSlot(item_slot)
		if individual_item then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
			illusion:AddItem(illusion_duplicate_item)
		end
	end
	
	-- Добавляем модификатор иллюзии
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {
		duration = illusion_duration,
		outgoing_damage = illusion_outgoing_damage,
		incoming_damage = illusion_incoming_damage
	})
	
	illusion:MakeIllusion()

	return illusion
end

--[[ ============================================================================================================
	Author: Rook
	Date: February 2, 2015
	Called when Manta Style is cast.
================================================================================================================= ]]
function item_manta_datadriven_on_spell_start(keys)
	-- Устанавливаем сниженный кулдаун для ближнего боя
	if not keys.caster:IsRangedAttacker() then
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(keys.CooldownMelee)
	end
	
	-- Создаем эффект активации
	local manta_particle = ParticleManager:CreateParticle("particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	Timers:CreateTimer(keys.InvulnerabilityDuration, function()
		ParticleManager:DestroyParticle(manta_particle, false)
	end)
	
	keys.caster:EmitSound("DOTA_Item.Manta.Activate")
	
	-- Очищаем дебаффы и уклоняемся от снарядов
	keys.caster:Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge(keys.caster)
	
	-- Делаем героя неуязвимым и невидимым
	keys.ability:CreateVisibilityNode(keys.caster:GetAbsOrigin(), keys.VisionRadius, keys.InvulnerabilityDuration)
	keys.caster:AddNoDraw()
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_manta_datadriven_invulnerability", nil)
end

--[[ ============================================================================================================
	Author: Rook
	Date: February 2, 2015
	Called after Manta Style's invulnerability period ends.
================================================================================================================= ]]
function modifier_item_manta_datadriven_invulnerability_on_destroy(keys)
	local caster_origin = keys.caster:GetAbsOrigin()
	
	-- Определяем позиции для иллюзий
	local positions = {
		Vector(0, 100, 0),   -- North
		Vector(0, -100, 0),  -- South  
		Vector(100, 0, 0),   -- East
		Vector(-100, 0, 0)   -- West
	}
	
	-- Выбираем случайные направления для иллюзий
	local illusion1_dir = RandomInt(1, 4)
	local illusion2_dir = (RandomInt(1, 3) + illusion1_dir) % 4 + 1
	
	local illusion1_origin = caster_origin + positions[illusion1_dir]
	local illusion2_origin = caster_origin + positions[illusion2_dir]
	
	-- Создаем иллюзии с соответствующими параметрами
	local illusion_params = keys.caster:IsRangedAttacker() and {
		incoming = keys.IllusionIncomingDamageRanged,
		outgoing = keys.IllusionOutgoingDamageRanged
	} or {
		incoming = keys.IllusionIncomingDamageMelee,
		outgoing = keys.IllusionOutgoingDamageMelee
	}
	
	local illusion1 = create_illusion(keys, illusion1_origin, illusion_params.incoming, illusion_params.outgoing, keys.IllusionDuration)
	local illusion2 = create_illusion(keys, illusion2_origin, illusion_params.incoming, illusion_params.outgoing, keys.IllusionDuration)
	
	-- Обновляем позиции после создания
	illusion1_origin = illusion1:GetAbsOrigin()
	illusion2_origin = illusion2:GetAbsOrigin()
	
	-- Устанавливаем направление всех юнитов
	local caster_forward_vector = keys.caster:GetForwardVector()
	illusion1:SetForwardVector(caster_forward_vector)
	illusion2:SetForwardVector(caster_forward_vector)
	
	-- Рандомизируем позиции
	local positions_table = {
		[1] = caster_origin,
		[2] = illusion1_origin,
		[3] = illusion2_origin
	}
	
	local units = {keys.caster, illusion1, illusion2}
	local used_positions = {}
	
	for i = 1, 3 do
		local unit = units[i]
		local pos_index
		repeat
			pos_index = RandomInt(1, 3)
		until not used_positions[pos_index]
		used_positions[pos_index] = true
		unit:SetAbsOrigin(positions_table[pos_index])
	end
	
	-- Восстанавливаем видимость героя
	keys.caster:RemoveNoDraw()
	
	-- Синхронизируем здоровье и ману
	local caster_health = keys.caster:GetHealth()
	local caster_mana = keys.caster:GetMana()
	illusion1:SetHealth(caster_health)
	illusion1:SetMana(caster_mana)
	illusion2:SetHealth(caster_health)
	illusion2:SetMana(caster_mana)
end