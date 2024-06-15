

--local current_modname = nil
local last_run_mod = nil

function minetest.get_builtin_path()
  return test_api.minetest_install_dir.."builtin/"
end

-- register
function minetest.register_item_raw(itemdef)
  --minetest.registered_items[itemdef.name] = itemdef
end
function minetest.unregister_item_raw(name)
end
function minetest.register_alias_raw(alias, origin_name)
  --minetest.registered_items[alias] = minetest.registered_items[origin_name]
end

function minetest.get_modpath(modname)
  return test_api.loaded_mods[modname]
end
function minetest.get_current_modname()
  return test_api.current_modname
end

function minetest.get_worldpath()
  assert(MINETEST_WORLD_PATH, "Global variable MINETEST_WORLD_PATH is undefined. Pleae define MINETEST_WORLD_PATH or MINETEST_WORLD_SUBPATH before loading test_api init.lua file.")
  return MINETEST_WORLD_PATH
end

function minetest.log(level, message)
  print("[EMULATED LOG "..level.."]: "..message)
end
--[[

local function translate(text)
  return text
end

function minetest.get_translator(name)
  return translate
end

function minetest.chat_send_player(playername, message)
  print("[EMULATED CHAT FOR "..playername.."]: "..message)
end


minetest.registered_items = {}  
minetest.registered_nodes = {}  
minetest.registered_craftitems = {}  
minetest.registered_tools = {}  

--]]

-- http

function minetest.set_http_api_lua(callback)
  -- nothing is done by this
end

-- last run mod
function minetest.set_last_run_mod(modname)
  last_run_mod = modname
end
function minetest.get_last_run_mod()
  return last_run_mod
end

