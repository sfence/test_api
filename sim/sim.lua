
local dir = string.sub(debug.getinfo(1).source,2,-8)

print(dir)

dofile(dir.."running.lua")
dofile(dir.."map.lua")
dofile(dir.."players.lua")
dofile(dir.."interactions.lua")

