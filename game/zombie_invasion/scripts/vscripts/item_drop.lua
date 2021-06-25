
if ItemDrop == nil then
	_G.ItemDrop = class({})
end

ItemDrop.item_drop = {
--		{items = {"item_branches"}, chance = 5, duration = 5, limit = 3, units = {} },
		{items = {"item_meat"}, chance = 35, duration = 300, units = {"npc_classic_pig"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_milk"}, chance = 35, duration = 300, units = {"npc_classic_sheep"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_zombie_skin"}, chance = 1,  units = {"npc_classic_half_zombie"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_eggs"}, chance = 20, duration = 300, units = {"npc_classic_chicken"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_eggs"}, chance = 35, duration = 300, units = {"npc_stronger_chicken"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_bone"}, chance = 20, duration = 300, units = {"npc_classic_skelet"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		{items = {"item_bone"}, chance = 100, duration = 300, units = {"npc_classic_skeleton_king"}},--50% drop from list with limit --limit -это скольк таких итемов может выпасть
		--{items = {"item_flask"}, chance = 25, duration = 10},-- global drop 25%   --имхо вообще не рулит...залочивает слот. выкинь-подбери - нееее!!! так не пойдет!!!
		{items = {"item_corica"}, units ={"npc_classic_witch"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_bag_of_gold"}, units ={"npc_classic_witch"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_bag_of_gold_pig"}, units ={"npc_boss_pig"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_big_meat"}, units ={"npc_boss_pig"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_bag_of_gold"}, units ={"npc_boss_dead_pig"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_dead_golova"}, units ={"npc_boss_dead_pig"}},      -- если указан units - то итем может упасть тольк с этих юнитов
		{items = {"item_bag_of_gold_mutant"}, units ={"npc_boss_mutant"}},      -- если указан units - то итем может упасть тольк с этих юнитов  
		{items = {"item_undying_heart"}, units ={"npc_boss_mutant"}},      -- если указан units - то итем может упасть тольк с этих юнитов
        
        {items = {"item_up_speed_tower"}, chance = 1, duration = 300, units = {"npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
        {items = {"item_up_armor_tower"}, chance = 1, duration = 300, units =  {"npc_classic_pig", "npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
        {items = {"item_up_dmg_tower"}, chance = 1, duration = 300, units =  {"npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
        {items = {"item_up_ability_tower4"}, chance = 1, duration = 300, units =  {"npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
        {items = {"item_up_ability_tower3"}, chance = 1, duration = 300, units =  {"npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
        {items = {"item_up_ability_tower2"}, chance = 1, duration = 300, units =  {"npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
        {items = {"item_up_ability_tower"}, chance = 1, duration = 300, units =  {"npc_classic_necr", "npc_classic_big_zombie", "npc_classic_zombie", "npc_classic_skelet", 
        "npc_classic_skeleton_king", "npc_classic_pudge", "npc_classic_pudge2", "npc_classic_pudge3", "npc_classic_pudge4", "npc_classic_pudge5"}},
 
		{items = {"item_saxar_svekla"}, units ={"npc_dota_bochok_saxara"}},
		{items = {"item_magic_heart"}, units ={"npc_dota_bochok_saxara"}},
		--все что ниже нахимичил ЕНОТ. А енотов бить нельзя кста!!!=)
--		{items = {"item_letter"},  units = {"npc_mini_elka_1","npc_mini_elka_2","npc_mini_elka_3","npc_mini_elka_4","npc_mini_elka_5","npc_mini_elka_6"}},-- chance = шанс дропа со всех -Х(стока-то)%, пропадает(уничтожается с карты) через duration = 10 сек если не поднять!
 --	{items = {"item_bonus_health","item_bonus_health_regen","item_bonus_mana_regen","item_bonus_mana","item_bonus_damage","item_bonus_spell"},chance = 5,duration = 25  },
}

ItemDrop.secret_items = {
--	["point_name"] = "item_name",
 

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
		local point = Entities:FindByName(nil, point_name)
		if point then
			point = point:GetAbsOrigin()
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionSync( point, newItem )
		else
			print("point with name "..point_name.." dont exist !")
		end
	end
end

function ItemDrop:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local name = killedUnit:GetUnitName()
	local team = killedUnit:GetTeam()

	if team ~= DOTA_TEAM_GOODGUYS and name ~= "npc_dota_thinker" then
		ItemDrop:RollItemDrop(killedUnit)
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