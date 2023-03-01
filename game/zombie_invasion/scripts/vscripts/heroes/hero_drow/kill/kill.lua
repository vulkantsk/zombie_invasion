--[[
	Author: kritth
	Date: 1.1.2015.
	Check number of units every interval
	Note: Might be possible to do entirely in datadriven, however, I seem to crash everytime I tried
	to do so, insteads, I just use simple script
]]
function kill( keys )

	local target = keys.target

	
	
   target:Kill(keys.ability, keys.caster)
	
	
end
