 
	item_test = class({})

    local test_off = 0
 function item_test:OnSpellStart()
	--print("OnSpellStart")
	local sound = "Slow_mobs_1"
  if randomheroess >= 1 then 
 InvasionMode:RandomHeroes()
 end  
test_off = test_off + 1
  if test_off%2 == 1 then 
  EmitGlobalSound(sound)
else 
   StopGlobalSound(sound)
end

end