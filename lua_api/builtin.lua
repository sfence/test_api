
local dir = test_api.minetest_install_dir

INIT = "game"
DIR_DELIM = "/"

-- old LUA support
if (_VERSION~="Lua 5.1") then
  function loadstring(...)
    error("[test_api] Function loadstring is defined only for limit warning. It is not allowed to call it.")
  end
  function setfenv(...)
    error("[test_api] Function loadstring is defined only for limit warning. It is not allowed to call it.")
  end
end

dofile(dir.."builtin/init.lua")

