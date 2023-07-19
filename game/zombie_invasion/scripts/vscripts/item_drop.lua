
if ItemDrop == nil then
	_G.ItemDrop = class({})
end

ItemDrop.item_drop = {
--		{items = {"item_branches"}, chance = 5, duration = 5, limit = 3, units = {} },
		{items = {"item_meat"}, chance = 35, duration = 20, units = {"npc_classic_pig"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_meat"}, chance = 53, duration = 20, units = {"npc_classic_big_pig"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_milk"}, chance = 35, duration = 20, units = {"npc_classic_sheep"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_milk"}, chance = 53, duration = 20, units = {"npc_classic_big_sheep"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_bone"}, units ={"npc_cemetery_skelet"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_eggs"}, chance = 20, duration = 20, units = {"npc_classic_chicken"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_eggs"}, chance = 30, duration = 20, units = {"npc_stronger_chicken"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_necr_heart"}, chance = 20, duration = 20, units = {"npc_classic_necr"}}, 
		{items = {"item_necr_heart"}, chance = 30, duration = 20, units = {"npc_classic_big_necr"}}, 		
		{items = {"item_bone"}, chance = 5, duration = 20, units = {"npc_classic_woobleydog2"}},  
		{items = {"item_bone"}, chance = 5, duration = 20, units = {"npc_classic_woobleydog"}},  
		{items = {"item_ess_pudge"}, chance = 13, limit = 6, units = {"npc_classic_skelet_ruin"}},
		{items = {"item_bone"}, chance = 20, duration = 12, units = {"npc_classic_dragon_small"}},
		{items = {"item_bone"}, chance = 25, duration = 12, units = {"npc_classic_dragon_big"}}, 
		{items = {"item_ess_pudge"}, chance = 10,duration = 20, units = {"npc_classic_skelet_ruin"}}, 
		{items = {"item_necr_heart"}, chance = 7,duration = 20, units = {"npc_classic_microchel"}}, 
		{items = {"item_basher"}, chance = 100, units = {"npc_boss_slardar"}},
		{items = {"item_cursed_shield"}, chance = 100, units = {"npc_boss_bear"}},
		{items = {"item_bone"}, min_count = 3, max_count = 4 ,units ={"npc_boss_bear"}},
		{items = {"item_piercing_blade"}, chance = 100, units = {"npc_classic_Night_Stalker_boss"}},
		{items = {"item_unactive_midas"}, chance = 100, units = {"npc_boss_Gurd"}},
		{items = {"item_pizza2"}, chance = 100, units = {"npc_boss_Gurd"}},
		{items = {"item_dragon_scale_quest"}, chance = 100, units = {"npc_classic_dragon"}},
		{items = {"item_alduin_soul"}, chance = 100, units = {"npc_classic_alduin_boss"}},
		{items = {"item_big_meat"}, chance = 100, units = {"npc_boss_pig"}},
		{items = {"item_law_frog"}, chance = 7,daration = 20, units = {"npc_classic_frog"}},
		{items = {"item_fish"}, chance = 100, units = {"npc_boss_slardar"}},
		{items = {"item_adulin"}, chance = 100, units = {"npc_classic_alduin_boss"}},
 
  

 		{items = {"item_aghanims_shard_roshan"}, units ={"npc_witch_boss_1"}},	
		{items = {"item_aghanims_shard_roshan"}, max_count = 2, units  ={"npc_witch_boss_2"}},


		{items = {"item_aghanims_shard_roshan"}, units ={"npc_witch_boss_3"}},   
		{items = {"item_magic_heart"}, units ={"npc_witch_boss_3"}},   

		{items = {"item_bag_of_gold"}, units ={"npc_boss_dead_pig"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_dead_golova"}, units ={"npc_boss_dead_pig"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_bag_of_gold_mutant"}, units ={"npc_boss_mutant"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_undying_heart"}, units ={"npc_boss_mutant"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_tres_jo"}, units ={"npc_boss_mutant"}},      -- если указан units - то итем может упасть тольк с этих юнитов       
		{items = {"item_eggs"}, min_count = 2, max_count = 5 ,units ={"npc_boss_slark"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_brassiere"},chance = 100, units ={"npc_boss_slark"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_zombie_skin"},chance = 5, units ={"npc_classic_half_zombie"}},      -- если указан units - то итем может упасть тольк с этих юнитов  

  
  
		--все что ниже нахимичил ЕНОТ. А енотов бить нельзя кста!!!=)

-- ***********************************     НОВЫЙ ГОД   ***************************
--		{items = {"item_letter"},  units = {"npc_mini_elka_1","npc_mini_elka_2","npc_mini_elka_3","npc_mini_elka_4","npc_mini_elka_5","npc_mini_elka_6"}},-- chance = шанс дропа со всех -Х(стока-то)%, пропадает(уничтожается с карты) через duration = 10 сек если не поднять!
--  {items = {"item_bonus_health","item_bonus_health_regen","item_bonus_mana_regen","item_bonus_mana","item_bonus_damage","item_bonus_spell"},chance = 5,duration = 25  },
 
 --  ***********************************  ХЭЛУИН    ***********************************
  	--	{items = {"item_candy"}, chance = 5, duration = 25}, 
}

ItemDrop.secret_items = {
--	["point_name"] = "item_name",

--[[ 
 ["secret_1"] = "item_bonus_health1",
 ["secret_2"] = "item_bag_of_gold_pig", 
 ["secret_3"] = "item_bonus_damage1",
 ["secret_4"] = "item_bonus_spell1",
 ["secret_5"] = "item_bonus_health1",
 ["secret_6"] = "item_bonus_damage1",
 ["secret_7"] = "item_bonus_spell1",
]]
}
function ItemDrop:InitGameMode()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)
end

function ItemDrop:OnGameRulesStateChange()
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		ItemDrop:SpawnItems()
	end
end

function ItemDrop:SpawnItems()
	local items = self.secret_items
	for point_name,item_name in pairs(items) do
		local points = Entities:FindAllByName(point_name)
		if points then
			for i=1,#points do
				  local point = points[i]
			    point = point:GetAbsOrigin()
			    local newItem = CreateItem( item_name, nil, nil )
			    local drop = CreateItemOnPositionSync( point, newItem )
		  end
		else
			print("point with name "..point_name.." dont exist !")
		end
	end
end

function ItemDrop:OnEntityKilled( keys )
 
 
local hVictim = nil
local hAttacker = nil
if keys.entindex_killed ~= nil then
hVictim = EntIndexToHScript( keys.entindex_killed )
  if hVictim:HasModifier("modifier_zombie_passive_fire") then  
  	return nil
  end

ItemDrop:RollItemDrop(hVictim)
end
if keys.entindex_attacker ~= nil then
hAttacker = EntIndexToHScript( keys.entindex_attacker )
end

if keys.entindex_killed == nil then
return nil 
end

 
if keys.entindex_attacker == nil then
return nil 
end


if hVictim == nil then
return nil 

end

if hVictim:IsReincarnating() then
return nil 

end

end

function ItemDrop:RollItemDrop(unit)
	local unit_name = unit:GetUnitName()

	for _,drop in ipairs(self.item_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil -- если юниты не были определены, то срабатывает для любого
		local chance = drop.chance or 100 -- если шанс не был определен, то он равен 100
		local loot_duration = drop.duration or nil -- длительность жизни предмета на земле
		local limit = drop.limit or nil -- лимит предметов
		local item_name = items[1] -- название предмета
		local roll_chance = RandomFloat(0, 100)

		local min_count = drop.min_count or 1 -- минимум выпавших предметов
		local max_count = drop.max_count or 1 -- максимум предметов
    local random_count = RandomInt(min_count,max_count)

		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end
 
      for i=1,random_count do 
			local spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", 
					function() 
						if drop:IsNull() then
							return
						end

						local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
						ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
						ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
					--	EmitGlobalSound("Item.PickUpWorld")

						UTIL_Remove( item )
						UTIL_Remove( drop )
					end, loot_duration )
			end
      end

		end

	end	
end

function KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
--	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

ItemDrop:InitGameMode()