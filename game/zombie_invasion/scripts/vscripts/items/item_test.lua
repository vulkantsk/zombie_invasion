 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
      if test_off == 0 then 
            test_off = 1
                  CustomGameEventManager:Send_ServerToAllClients("wait_player", {})
      elseif test_off == 1 then 
            test_off = 0
            CustomGameEventManager:Send_ServerToAllClients("disable_wait_player", {})
      end
    --InvasionMode:BeginEdgardTimer()

                   --     self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_vision", {})
                 -- EmitGlobalSound("massive_blood")
end