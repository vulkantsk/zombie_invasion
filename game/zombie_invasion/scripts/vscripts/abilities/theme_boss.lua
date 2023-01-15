function Genocide(keys)
	local caster = keys.caster
 
	local sound = keys.sound
 
   Sounds:CreateGlobalLoopingSound( sound )
--	EmitSoundOn(sound, caster)

end


function GenocideEnd(keys)
	Sounds:RemoveGlobalLoopingSound( "Asgore_main_classic" )
end
 
function EndChristmas(keys)
	Sounds:RemoveGlobalLoopingSound( "christmas_boss_theme" )
end