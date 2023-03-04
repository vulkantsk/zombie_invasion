FirstSpawned = {}


DONATE_SET_HELPER = {
	players = {
	206968098,
	203159402,
	946902506
	},
}

DONATE_SET_ADMIN = {
	players = {
		453736017,
		877002179,

	},
}

DONATE_ITEM_SLARK = {
	players = {
--		347624347,
          206968098,
          203159402,
          432431747,
          946902506
	},	
}

DONATE_ITEM_SHINOBU = {
	players = {

	},	
}

DONATE_ITEM_MIDAS = {
	players = {
--		347624347,
206968098,
203159402,
946902506

	},	
}


DONATE_ITEMS = {
	heroes = {
		{
			name = "item_larks_change",
			can_be_bought = true,
			count = 1,
			sets ={
				DONATE_SET_ADMIN,
				DONATE_ITEM_SLARK,
				DONATE_SET_HELPER,
			},
		},
		{
			name = "item_strenobu_change",
			can_be_bought = true,
			count = 1,
			sets ={
				DONATE_SET_ADMIN,
				DONATE_ITEM_SHINOBU,
			},
		},

	},
	artifacts = {

		{
			name = "item_midas_donate",
			count = 1,
			sets ={
				DONATE_SET_ADMIN,
				DONATE_ITEM_MIDAS,
				DONATE_SET_HELPER,
			},
		},
		{
			name = "item_admin",
			count = 1,
			sets ={
				DONATE_SET_ADMIN,
			},
		},



	},
}

Donate = Donate or class({})

function Donate:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self.players = {}
		for p = 0, PlayerResource:GetPlayerCount() - 1 do
			self.players[p] = {}
			local acc_id = PlayerResource:GetSteamAccountID( p )
			local player = self.players[p]

			if acc_id then
				for list, items in pairs( DONATE_ITEMS ) do
					for _, item in pairs( items ) do
						local item_info = {
							name = item.name,
							sets = {}
						}
						local player_has = item.free_available or nil
						for _, set in pairs( item.sets ) do
							for _, id in pairs( set.players or {} ) do
								if id == acc_id then
									player_has = true
								end
							end
							if set.name and set.can_be_bought then
								local set_info = {
									name = set.name,
									can_be_bought = set.can_be_bought,
									free_available = set.free_available,
								}
								table.insert( item_info.sets, set_info )
							end
						end

						if item.can_be_bought or player_has then
							player[list] = player[list] or {}

							if player_has then
								item_info.count = item.count
							else
								item_info.count = -1
							end
							table.insert( player[list], item_info )
						end
					end
				end
			end
			self:UpdateNetTables( p )
		end
	end
end

function Donate:UpdateNetTables( pId )
	CustomNetTables:SetTableValue( "donate", tostring( pId ), self.players[pId] )
end

function Donate:PlayerTake( info )
	local self = Donate

	local player_data = self.players[info.id]
	if not player_data then return end

	local player = PlayerResource:GetPlayer( info.id )

	if player and player:GetAssignedHero() then
		for _, l in pairs( player_data ) do
			for _, i in pairs( l ) do
				if i.name == info.itemname and i.count > 0 then
					local hero = player:GetAssignedHero()
					for ii = 0, 8 do
						if not hero:GetItemInSlot( ii ) then
							player:GetAssignedHero():AddItemByName( i.name )
							i.count = i.count - 1
							self:UpdateNetTables( info.id )
							return
						end
					end
				end
			end
		end
	end
end

LinkLuaModifier( "modifier_special_effect_legendary", "modifiers/donate/modifier_special_effect_legendary", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_special_effect_slark_skin", "modifiers/donate/modifier_special_effect_legendary", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_special_effect_admin", "modifiers/donate/modifier_special_effect_admin", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_special_effect_admin2", "modifiers/donate/modifier_special_effect_admin", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_special_effect_admin3", "modifiers/donate/modifier_special_effect_admin", LUA_MODIFIER_MOTION_BOTH )
 
function Donate:OnNPCSpawned(keys)
	print("[BAREBONES] NPC Spawned")
--	DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)
	local name = npc:GetUnitName()
	
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		local playerID = npc:GetPlayerID()
		
		--npc:AddItemByName("item_skull_of_midas")
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		
		print( "Steam Community ID: " .. tostring( steamID ) )
		print( "Current Hero: " .. tostring( name ) )
--	
	
		addModifierBySteamID(DONATE_SET_HELPER.players,"modifier_special_effect_legendary",steamID,npc)
		addModifierBySteamID(DONATE_SET_ADMIN.players,"modifier_special_effect_slark_skin",steamID,npc)
		addModifierBySteamID(DONATE_SET_ADMIN.players,"modifier_special_effect_admin",steamID,npc)
		addModifierBySteamID(DONATE_SET_ADMIN.players,"modifier_special_effect_admin2",steamID,npc)
		addModifierBySteamID(DONATE_SET_ADMIN.players,"modifier_special_effect_admin3",steamID,npc)
--		addModifierBySteamID(				
--[[ 	
		if not FirstSpawned[playerID] then
			local point = npc:GetAbsOrigin()
			local team = npc:GetTeam()
			local unit = CreateUnitByName( "npc_dota_courier", point, true, npc, npc, team )
			unit:SetControllableByPlayer(npc:GetPlayerID(), true)

		end
			]]	
	end

end



function addModifierBySteamID(enum,modifier_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddNewModifier( npc, nil, modifier_name, nil) end)
		end
	end
end

ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Donate, "OnGameRulesStateChange" ), Donate )
ListenToGameEvent("npc_spawned",Dynamic_Wrap(Donate,'OnNPCSpawned'),Donate)
CustomGameEventManager:RegisterListener( "donate_player_take", Dynamic_Wrap( Donate, "PlayerTake" ) )
