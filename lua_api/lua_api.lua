
local dir = string.sub(debug.getinfo(1).source,2,-12)

--print(dir)

dofile(dir.."json.lua")

dofile(dir.."inventory.lua")
dofile(dir.."meta.lua")
--dofile(dir.."settings.lua") -- settings have to be loaded from main init, to make Setting object usable
dofile(dir.."itemstack.lua")

dofile(dir.."PcgRandom.lua")

dofile(dir.."core.lua")
dofile(dir.."crafting.lua")
dofile(dir.."mapgen.lua")

dofile(dir.."map.lua")

dofile(dir.."builtin.lua")

dofile(dir.."overrides.lua")

dofile(dir.."NodeTimerRef.lua")

-- vector is required to be defined
dofile(dir.."ObjectRef.lua")
dofile(dir.."LuaEntityRef.lua")
dofile(dir.."PlayerRef.lua")

