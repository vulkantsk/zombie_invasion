function Death( event )
    local target = event.target
    local caster = event.caster
	Timers:CreateTimer(10, function() caster:RespawnHero(false,false) end )	
	caster:RemoveModifierByName("modifier_aphotic_shield")
	caster:ForceKill(true)

end