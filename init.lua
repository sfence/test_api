
test_api = {}

local dir = string.sub(debug.getinfo(1).source,2,-9)

print(dir)

dofile(dir.."test_api.lua")
dofile(dir.."common.lua")
dofile(dir.."meta.lua")
dofile(dir.."minetest.lua")
dofile(dir.."settings.lua")
dofile(dir.."itemstack.lua")

dofile(dir.."extra_graph.lua")
