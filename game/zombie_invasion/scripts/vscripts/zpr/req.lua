--
require "zpr/events"
require "zpr/spawns"
--

--
function zprInit()
	print("ZPR LOADING")
	ZEvent:init()
	ZSpawn:init()
	print("ZPR LOADED")
end
--