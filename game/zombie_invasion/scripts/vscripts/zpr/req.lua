--
require "zpr/events"
require "zpr/spawns"
require "zpr/filters"
--

--
function zprInit()
	print("ZPR LOADING")
	ZEvent:init()
	ZFilter:init()
	print("ZPR LOADED")
end
--