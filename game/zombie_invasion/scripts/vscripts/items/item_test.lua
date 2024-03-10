 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
              --    CustomGameEventManager:Send_ServerToAllClients("edgard_end", {})
    --InvasionMode:BeginEdgardTimer()

                   --     self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_vision", {})
                  EmitGlobalSound("massive_blood")
end