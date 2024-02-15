 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
        ScreenShake( self:GetParent():GetOrigin(), 1000.0, 100.0, 3, 2000.0, 0, true )

end