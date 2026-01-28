 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()

    --InvasionMode:BeginEdgardTimer()

                   --     self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_vision", {})
                   print("EmitGlobalSound")
                  local sound2 = self:GetCaster():EmitSound("CMH Lida - STIKER")
                  local sound = EmitGlobalSound("CMH Lida - STIKER")
                  print(sound2)
                  print(sound)
                  EmitGlobalSound("CMH Lida - STIKER")
                    if self:GetCaster():GetPrimaryAttribute() == 0 then
                  
                     Convars:SetFloat("host_timescale", 10);
                     end

    --InvasionMode:ChristmasNight() 
end