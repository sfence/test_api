
test_api.settings = {}

function Settings(filename)
  return test_api.settings:new(filename)
end

-- this have to be called on end of this file
--minetest.settings = Settings(nil)

function test_api.settings:new(filename)
  local new_setting = {}
  setmetatable(new_setting, {__index = self})
  new_setting.filename = filename
  return new_setting
end

test_api.settings.keys = {}

function test_api.settings:get(key)
  return self.keys[key]
end
function test_api.settings:get_bool(key, default)
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:get_np_group(key)
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:get_flags(key)
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:set(key, value)
  self.keys[key] = value
end
function test_api.settings:set_bool(key, value)
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:set_no_group(key, value)
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:remove(key)
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:get_names()
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:write()
  error("[test_api]: Method is not implemented.")
end
function test_api.settings:to_table()
  error("[test_api]: Method is not implemented.")
end

minetest.settings = Settings(nil)

