
local dir = string.sub(debug.getinfo(1).source,2,-15)

local file_settings = dir.."settings.conf"
local settings = Settings(nil)

print("[test_api] Trying to load settings file `"..file_settings.."`.")

local file = io.open(file_settings,"r")
if file then
  file:close()
  settings = Settings(file_settings)
  print("[test_api] Settings file `"..file_settings.."` loaded.")
end

test_api.minetest_install_dir = settings:get("minetest_install_dir")

if not test_api.minetest_install_dir then
  error("Missing minetest_install_dir. Please add settings.conf and set path.")
end
