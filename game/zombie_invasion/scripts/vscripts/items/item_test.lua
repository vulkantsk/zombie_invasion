 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
       CustomGameEventManager:Send_ServerToAllClients("edgard_disable_exit", {})

end