
test_api = {}

local dir = string.sub(debug.getinfo(1).source,2,-9)

test_api.BLOCK_SIZE = 16

--print(dir)

dofile(dir.."test_api.lua")

dofile(dir.."lua_api/settings.lua")
dofile(dir.."parameters.lua")

dofile(dir.."lua_api/lua_api.lua")
dofile(dir.."sim/sim.lua")

dofile(dir.."extra_graph.lua")
