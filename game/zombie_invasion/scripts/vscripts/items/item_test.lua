 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()

    --InvasionMode:BeginEdgardTimer()

                   --     self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_vision", {})
                 -- EmitGlobalSound("massive_blood")
           
                    if self:GetCaster():GetPrimaryAttribute() == 0 then
                  
                     Convars:SetFloat("host_timescale", 10);
                     end

    InvasionMode:ChristmasNight() 
end