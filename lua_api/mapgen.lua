
minetest.registered_biomes = {}
minetest.registered_ores = {}
minetest.registered_decorations = {}

local mapgen_setting = {}

function minetest.get_mapgen_setting(name)
  -- TODO
  return mapgen_setting[name]
end
function minetest.set_mapgen_setting(name, value, override_meta)
  -- TODO
  mapgen_setting[name] = value
end

function minetest.register_biome()
  
end
function minetest.clear_registered_biomes()
  minetest.registered_biomes = {}
end

function minetest.register_ore()
  
end
function minetest.clear_registered_ores()
  minetest.registered_ores = {}
end

function minetest.register_decoration()
  
end
function minetest.clear_registered_decorations()
  minetest.registered_decorations = {}
end
