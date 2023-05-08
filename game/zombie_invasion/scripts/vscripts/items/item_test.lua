 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
	--print("OnSpellStart")
--	local sound = "Slow_mobs_1"
	EmitGlobalSound("after_sleep")
end