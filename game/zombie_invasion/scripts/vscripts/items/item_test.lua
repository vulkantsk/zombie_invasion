 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
	--print("OnSpellStart")
	local sound = "Bing Crosby, The Andrews Sisters - Santa Claus is Coming to Town"

test_off = test_off + 1
  if test_off%2 == 1 then 
  EmitGlobalSound(sound)
else 
   StopGlobalSound(sound)
end

end