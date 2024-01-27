 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
 	CustomGameEventManager:Send_ServerToAllClients( "give_reward", {
 		rewards = {"item_bottle", "item_eggs", "item_admin"}
 	})
end