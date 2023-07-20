function GetDirectoryFromPath(path)
	return path:match("(.*[/\\])")
end

function ModuleRequire(path,file)
	return require(GetDirectoryFromPath(path) .. file)
end

function math.round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function math.symbolsCount(num)
	return #(string.gsub(tostring(num),"%p+",''))
end

function GetMultipleBountyBonus(hUnit)
	local bonus = 0

	for _,modifier in pairs(hUnit:FindAllModifiers()) do
		if modifier.GetBountyMultiplyBonus then 
			bonus = bonus + modifier:GetBountyMultiplyBonus()
		end 
	end
	return bonus
end 


function CDOTABaseAbility:AutoStartCooldown()
	self:StartCooldown(self:GetReducedCooldown())
end

function CDOTA_BaseNPC:GetIllusionParent()
	local modifier_illusion = self:FindModifierByName("modifier_illusion")
	if modifier_illusion then
		return modifier_illusion:GetCaster()
	end
end

function CEntityInstance:SetNetworkableEntityInfo(key, value)
	local t = CustomNetTables:GetTableValue("custom_entity_values", tostring(self:GetEntityIndex())) or {}
	t[key] = value
	CustomNetTables:SetTableValue("custom_entity_values", tostring(self:GetEntityIndex()), t)
end


-- Autoattack lifesteal
function CDOTA_BaseNPC:GetLifesteal()
	local lifesteal = 0
	local multiplier = 0

	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifesteal and parent_modifier:GetModifierLifesteal() then
			lifesteal = lifesteal + parent_modifier:GetModifierLifesteal()
		end
	end

	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifestealAmplify and parent_modifier:GetModifierLifestealAmplify() then
			multiplier = multiplier + parent_modifier:GetModifierLifestealAmplify()
		end
	end

	if lifesteal ~= 0 and multiplier ~= 0 then
		lifesteal = lifesteal * (multiplier / 100)
	end

	return lifesteal
end

function CDOTA_BaseNPC:IsSameTeam(unit)
	return (self:GetTeamNumber() == unit:GetTeamNumber())
end

function CDOTA_BaseNPC:FindEnemyUnitsInRadius(position, radius, hData)
    if not self:IsNull() then
        local team = self:GetTeamNumber()
        local data = hData or {}
        local iTeam = data.team or DOTA_UNIT_TARGET_TEAM_ENEMY
        local iType = data.type or DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
        local iFlag = data.flag or DOTA_UNIT_TARGET_FLAG_NONE
        local iOrder = data.order or FIND_ANY_ORDER
        return FindUnitsInRadius(team, position, nil, radius, iTeam, iType, iFlag, iOrder, false)
    else return {} end
end

function CDOTA_BaseNPC:HasShard()

	if self:HasModifier("modifier_item_aghanims_shard") then
		return true
	else
        return false 
	end
end

function GiveExperiencePlayers( experience )
	for index=0 ,PlayerResource:GetPlayerCount() do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			hero:AddExperience(experience, 0, false, true )
		end
	end
end


function ChangeAttackProjectileImba(unit)

	local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
	local particle_skadi = "particles/items2_fx/skadi_projectile.vpcf"
	local particle_lifesteal = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"
	local particle_deso_skadi = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"
	local particle_clinkz_arrows = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	local particle_dragon_form_green = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	local particle_dragon_form_red = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
	local particle_dragon_form_blue = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
	local particle_terrorblade_transform = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

	-- If the unit has a Desolator and a Skadi, use the special projectile
	if unit:HasModifier("modifier_item_imba_desolator") or unit:HasModifier("modifier_item_imba_desolator_2") then
		if unit:HasModifier("modifier_item_imba_skadi") then
			unit:SetRangedProjectileName(particle_deso_skadi)
		-- If only a Desolator, use its attack projectile instead
		else
			unit:SetRangedProjectileName(particle_deso)
		end
	-- If only a Skadi, use its attack projectile instead
	elseif unit:HasModifier("modifier_item_imba_skadi") then
		unit:SetRangedProjectileName(particle_skadi)

	-- If the unit has any form of lifesteal, use the lifesteal projectile
	elseif unit:HasModifier("modifier_imba_morbid_mask") or unit:HasModifier("modifier_imba_mask_of_madness") or unit:HasModifier("modifier_imba_satanic") or unit:HasModifier("modifier_item_imba_vladmir") or unit:HasModifier("modifier_item_imba_vladmir_blood") then		
		unit:SetRangedProjectileName(particle_lifesteal)	

	-- If it's one of Dragon Knight's forms, use its attack projectile instead
	elseif unit:HasModifier("modifier_dragon_knight_corrosive_breath") then
		unit:SetRangedProjectileName(particle_dragon_form_green)
	elseif unit:HasModifier("modifier_dragon_knight_splash_attack") then
		unit:SetRangedProjectileName(particle_dragon_form_red)
	elseif unit:HasModifier("modifier_dragon_knight_frost_breath") then
		unit:SetRangedProjectileName(particle_dragon_form_blue)

	-- If it's a metamorphosed Terrorblade, use its attack projectile instead
	elseif unit:HasModifier("modifier_terrorblade_metamorphosis") then
		unit:SetRangedProjectileName(particle_terrorblade_transform)

	-- Else, default to the base ranged projectile
	else
--		print(unit:GetKeyValue("ProjectileModel"))
		unit:SetRangedProjectileName(unit:GetKeyValue("ProjectileModel"))
	end
end

 
 function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx
    if pfx == "gold" or pfx == "lumber" then
        pidx = ParticleManager:CreateParticleForTeam(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target, target:GetTeamNumber())
    else
        pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target)
    end

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

 

function PopupCriticalDamage(target, amount)
    PopupNumbers(target, "crit", Vector(255, 0, 0), 1.0, amount, nil, 4)
end

function SetGoldMultiplier(unit, multiplier)

    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * multiplier)
    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * multiplier)

end

function SetGoldUsually(unit, constant)

    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() + constant)
    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() + constant)

end

function SetExpUsually(unit, constant)

    unit:SetDeathXP(unit:GetDeathXP() + constant) 

end

function CDOTA_Buff:GetSharedKey(key)
	local t = CustomNetTables:GetTableValue("shared_modifiers", self:GetParent():GetEntityIndex() .. "_" .. self:GetName()) or {}
	return t[key]
end

function UpgradeUnitStats(unit, multiplier)
    if not unit:IsAlive() then
        return
    end

    
        local new_armor = unit:GetPhysicalArmorBaseValue() * multiplier
        local max_hp = unit:GetMaxHealth() * multiplier
        local min_dmg = unit:GetBaseDamageMin() * multiplier
        local max_dmg = unit:GetBaseDamageMax() * multiplier

        if max_hp <= 1 then
            max_hp = 1
        end
        unit:SetBaseMaxHealth(max_hp)
        unit:SetMaxHealth(max_hp)
        unit:SetHealth(max_hp)

        unit:SetPhysicalArmorBaseValue(new_armor)
        unit:SetBaseDamageMin(min_dmg)
        unit:SetBaseDamageMax(max_dmg)
 
end

function UpgradeWitchStats(unit, armor, hp, damage)
    if not unit:IsAlive() then
        return
    end

    
        local new_armor = unit:GetPhysicalArmorBaseValue() + armor
        local max_hp = unit:GetMaxHealth() + hp
        local min_dmg = unit:GetBaseDamageMin() + damage
        local max_dmg = unit:GetBaseDamageMax() + damage

        if max_hp <= 1 then
            max_hp = 1
        end
        unit:SetBaseMaxHealth(max_hp)
        unit:SetMaxHealth(max_hp)
        unit:SetHealth(max_hp)

        unit:SetPhysicalArmorBaseValue(new_armor)
        unit:SetBaseDamageMin(min_dmg)
        unit:SetBaseDamageMax(max_dmg)
 
end


function SetLevelForSubAbility(main_ability, sub_ability_name, target, level_required, level_to_set)
	local main_ability_level = main_ability:GetLevel()
	local sub_ability = target:FindAbilityByName(sub_ability_name)
	if sub_ability == nil then
		return
	end
	
	if main_ability_level < level_required then
		return
	end
	
	if level_to_set == nil then
		sub_ability:SetLevel(main_ability_level)
	else
		sub_ability:SetLevel(level_to_set)
	end
	
end

function CDOTA_BaseNPC:FindEnemyUnitsInLine(startPos, endPos, width, hData)
	local team = self:GetTeamNumber()
	local data = hData or {}
	local iTeam = data.team or DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = data.type or DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = data.flag or DOTA_UNIT_TARGET_FLAG_NONE
	return FindUnitsInLine(team, startPos, endPos, nil, width, iTeam, iType, iFlag)
end

function table.length(tbl)
	local count = 0 

	for k,v in pairs(tbl) do
		count = count + 1
	end 

	return count
end 

function CDOTA_BaseNPC:DamageHell() 
	if self:HasModifier("modifier_overheating") then 
		local modif = self:FindModifierByName("modifier_overheating")
		return modif:GetStackCount()/100 + 1 
	else 
		return 1 
	end

end

function CDOTA_BaseNPC:ModifierStackInc(modifier, setStack,dur,beginStack,ability)
	if self:HasModifier(modifier) then 
		local modif = self:FindModifierByName(modifier)
		modif:SetStackCount(modif:GetStackCount() + setStack)
		modif:SetDuration(dur, true)
	else
		local modif = self:AddNewModifier(self,ability,modifier,{duration = dur})
		modif:SetStackCount(beginStack)
	end
end
function CDOTA_BaseNPC:FilterModifiers(callback)
	local list = {}
	if not callback then print('[FilterModifiers] Error! Callback not found') return list end
	for k,v in pairs(self:FindAllModifiers()) do
		if callback(v) then 
			table.insert(list,v)
		end 
	end 

	return list
end 

--[[
	ability
	modifier
	duration
	count
	updateStack
	caster
	data
]]
function CDOTA_BaseNPC:AddStackModifier(data)
	data.data = data.data or {}
	data.data.duration = (data.duration or -1)
	if self:HasModifier(data.modifier) then
		local current_stack = self:GetModifierStackCount( data.modifier, data.ability )
		if data.updateStack then
			self:AddNewModifier(data.caster or self, data.ability,data.modifier,data.data)
		end
		self:SetModifierStackCount( data.modifier, data.ability, current_stack + (data.count or 1) )
		if self:GetModifierStackCount( data.modifier, data.ability ) < 1 then
			self:RemoveModifierByName(data.modifier)
		end
	else
		self:AddNewModifier(data.caster or self, data.ability,data.modifier,data.data)
		self:SetModifierStackCount( data.modifier, data.ability, (data.count or 1) )
	end
	return self:GetModifierStackCount( data.modifier, data.ability )
end

function IsHeroOrCreep(unit)
	if unit.IsCreep and unit:IsCreep() then
		return true
	elseif unit.IsHero and unit:IsHero() then
		return true
	end
	return false
end


function RollPseudoRandom(base_chance, entity)
	local chances_table = { {5, 0.38},
							{10, 1.48},
							{15, 3.22},
							{16, 3.65},
							{17, 4.09},
							{19, 5.06},
							{20, 5.57},
							{21, 6.11},
							{22, 6.67},
							{24, 7.85},
							{25, 8.48},
							{27, 9.78},
							{30, 11.9},
							{35, 15.8},
							{40, 20.20},
							{50, 30.20},
							{60, 42.30},
							{70, 57.10},
							{100, 100}
						  }

	entity.pseudoRandomModifier = entity.pseudoRandomModifier or 0
	local prngBase
	for i = 1, #chances_table do
		if base_chance == chances_table[i][1] then		  
			prngBase = chances_table[i][2]
		end	 
	end

	if not prngBase then
		print("The chance was not found! Make sure to add it to the table or change the value.")
		return false
	end
	
	if RollPercentage( prngBase + entity.pseudoRandomModifier ) then
		entity.pseudoRandomModifier = 0
		return true
	else
		entity.pseudoRandomModifier = entity.pseudoRandomModifier + prngBase		
		return false
	end
end

function DealDamage(source, target, damage, dType, flags, ability)
    local dTable = {
        victim = target,
        attacker = source,
        damage = damage,
        damage_type = dType,
        damage_flags = flags,
        ability = ability
    }
    ApplyDamage(dTable)
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end
  
	done = done or {}
	done[t] = true
	indent = indent or 0
  
	local l = {}
	for k, v in pairs(t) do
	  table.insert(l, k)
	end
  
	table.sort(l)
	for k, v in ipairs(l) do
	  -- Ignore FDesc
	  if v ~= 'FDesc' then
		local value = t[v]
  
		if type(value) == "table" and not done[value] then
		  done [value] = true
		  print(string.rep ("\t", indent)..tostring(v)..":")
		  PrintTable (value, indent + 2, done)
		elseif type(value) == "userdata" and not done[value] then
		  done [value] = true
		  print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		  PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
		  if t.FDesc and t.FDesc[v] then
			print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
		  else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		  end
		end
	  end
	end
  end

 -- https://github.com/Yahnich/Boss-Hunters/blob/6f1f7dc796ac2979932354353d7d5eea8a841b22/game/scripts/vscripts/libraries/utility.lua#L1825-L1853
function CDOTABaseAbility:FireLinearProjectile(FX, velocity, distance, width, data, bDelete, bVision, vision)
	local internalData = data or {}
	local delete = false
	if bDelete then delete = bDelete end
	local provideVision = true
	if bVision then provideVision = bVision end
	local info = {
		EffectName = FX,
		Ability = self,
		vSpawnOrigin = internalData.origin or self:GetCaster():GetAbsOrigin(), 
		fStartRadius = width,
		fEndRadius = internalData.width_end or width,
		vVelocity = velocity,
		fDistance = distance or 1000,
		Source = internalData.source or self:GetCaster(),
		iUnitTargetTeam = internalData.team or DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = internalData.type or DOTA_UNIT_TARGET_ALL,
		iUnitTargetFlags = internalData.type or DOTA_UNIT_TARGET_FLAG_NONE,
		iSourceAttachment = internalData.attach or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDeleteOnHit = delete,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bProvidesVision = provideVision,
		iVisionRadius = vision or 100,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData = internalData.extraData
	}
	local projectile = ProjectileManager:CreateLinearProjectile( info )
	return projectile
end

-- https://github.com/Yahnich/Boss-Hunters/blob/6f1f7dc796ac2979932354353d7d5eea8a841b22/game/scripts/vscripts/libraries/utility.lua#L180-L201
function CalculateDistance(ent1, ent2, b3D)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local vector = (pos1 - pos2)
	if b3D then
		return vector:Length()
	else
		return vector:Length2D()
	end
end
-- https://github.com/Yahnich/Boss-Hunters/blob/6f1f7dc796ac2979932354353d7d5eea8a841b22/game/scripts/vscripts/libraries/utility.lua#L180-L201
function CalculateDirection(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = (pos1 - pos2):Normalized()
	direction.z = 0
	return direction
end
-- https://github.com/Yahnich/Boss-Hunters/blob/6f1f7dc796ac2979932354353d7d5eea8a841b22/game/scripts/vscripts/libraries/utility.lua#L1684-L1697
function CDOTA_Modifier_Lua:StartMotionController()
	if not self:GetParent():IsNull() and not self:IsNull() and self.DoControlledMotion and self:GetParent():HasMovementCapability() then
		self:GetParent():StopMotionControllers()
		self:GetParent():InterruptMotionControllers(true)
		self.controlledMotionTimer = Timers:CreateTimer(function()
			if pcall( function() self:DoControlledMotion() end ) then
				return 0.03
			elseif not self:IsNull() then
				self:Destroy()
			end
		end)
	else
	end
end

-- https://github.com/Yahnich/Boss-Hunters/blob/6f1f7dc796ac2979932354353d7d5eea8a841b22/game/scripts/vscripts/libraries/utility.lua#L1754-L1758
function CDOTA_Modifier_Lua:StopMotionController(bForceDestroy)
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	if self.controlledMotionTimer then Timers:RemoveTimer(self.controlledMotionTimer) end
	if bForceDestroy then self:Destroy() end
end
-- https://github.com/Yahnich/Boss-Hunters/blob/6f1f7dc796ac2979932354353d7d5eea8a841b22/game/scripts/vscripts/libraries/utility.lua#L1760-L1767
function CDOTA_BaseNPC:StopMotionControllers(bForceDestroy)
	if self.InterruptMotionControllers then self:InterruptMotionControllers(true) end
	for _, modifier in ipairs( self:FindAllModifiers() ) do
		if modifier.controlledMotionTimer then 
			modifier:StopMotionController(bForceDestroy)
		end
	end
end
 
function CDOTA_BaseNPC_Hero:GetTotalHealthReduction()
	local pct = self:GetModifierStackCount("modifier_kadash_immortality_health_penalty", self)
	local mod = self:FindModifierByName("modifier_stegius_brightness_of_desolate_effect")
	if mod then
		pct = pct + mod:GetAbility():GetAbilitySpecial("health_decrease_pct")
	end

	local sara_evolution = self:FindAbilityByName("sara_evolution")
	if sara_evolution then
		local dec = sara_evolution:GetSpecialValueFor("health_reduction_pct")
		return dec + ((100-dec) * pct * 0.01)
	end
	return pct
end



function CDOTA_BaseNPC_Hero:CalculateHealthReduction()
	self:CalculateStatBonus(true)
	local pct = self:GetTotalHealthReduction()
	self:SetMaxHealth(pct >= 100 and 1 or self:GetMaxHealth() - pct * (self:GetMaxHealth()/100))
end

function CDOTABaseAbility:PerformPrecastActions()
	if self:IsCooldownReady() and self:IsOwnersManaEnough() then
		self:PayManaCost()
		self:AutoStartCooldown()
		--self:UseResources(true, true, true) -- not works with items?
		return true
	end
	return false
end

function CDOTABaseAbility:GetReducedCooldown()
	local biggestReduction = 0
	local unit = self:GetCaster()
	for k,v in pairs(COOLDOWN_REDUCTION_MODIFIERS) do
		if unit:HasModifier(k) then
			biggestReduction = math.max(biggestReduction, type(v) == "function" and v(unit) or v)
		end
	end
	return self:GetCooldown(math.max(self:GetLevel() - 1, 1)) * (100 - biggestReduction) * 0.01
end

COOLDOWN_REDUCTION_MODIFIERS = {
	modifier_octarine_unique_cooldown_reduction = function(unit)
		return GetAbilitySpecial(unit:HasModifier("modifier_item_refresher_core") and "item_refresher_core" or "item_octarine_core_arena", "bonus_cooldown_pct")
	end,
	--TODO Make it work without that table, rewrite modifier_octarine_unique_cooldown_reduction in modifier_lua
	modifier_arena_rune_arcane = function(unit)
		return unit:FindModifierByName("modifier_arena_rune_arcane"):GetModifierPercentageCooldown()
	end,
	modifier_talent_cooldown_reduction_pct = function(unit)
		return unit:FindModifierByName("modifier_talent_cooldown_reduction_pct"):GetModifierPercentageCooldown()
	end
}

function CDOTA_BaseNPC:IsRealCreep()
	return self.SSpawner ~= nil and self.SpawnerType ~= nil
end

function ModifyCreepDamage(keys)
	local caster = keys.caster
	local target = keys.target
	if target:IsRealCreep() then
		local ability = keys.ability
		local damage_bonus = keys.damage_bonus_ranged ~= nil and caster:IsRangedUnit() and keys.damage_bonus_ranged or keys.damage_bonus

		-- If not specified, assume that constant values are given
		local damage = keys.damage and
			(keys.damage * (damage_bonus * 0.01 - 1)) or
			damage_bonus

		ApplyDamage({
			attacker = caster,
			victim = target,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = keys.ability
		})
	end
end

function SimpleDamageReflect(victim, attacker, damage, flags, ability, damage_type)
	if victim:IsAlive() and bit.band(flags, DOTA_DAMAGE_FLAG_REFLECTION) == 0 and attacker:GetTeamNumber() ~= victim:GetTeamNumber() then
		ApplyDamage({
			victim = attacker,
			attacker = victim,
			damage = damage,
			damage_type = damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
			ability = ability
		})
		return true
	end
	return false
end