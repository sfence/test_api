
minetest = {}

local loaded_mods = {}
local current_modname = nil

function minetest.get_modpath(modname)
  return "."
end
function minetest.get_current_modname()
  return current_modname
end

function minetest.log(level, message)
  print("[EMULATED LOG "..level.."]: "..message)
end

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

-- special test api added methods

function test_api.load_module(path_to_dir, module_name)
  loaded_mods[module_name] = path_to_dir
  current_modname = module_name
  dofile(path_to_dir.."/init.lua")
  current_modname = nil
end

