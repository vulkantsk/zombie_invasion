 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()

    InvasionMode:BeginEdgardTimer()

                   --     self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_vision", {})
                 -- EmitGlobalSound("massive_blood")
end