
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
  if filename then
    new_setting:load_from_file(filename)
  end
  return new_setting
end

test_api.settings.keys = {}

function test_api.settings:get(key)
  return self.keys[key]
end
function test_api.settings:get_bool(key, default)
  local raw = self.keys[key]
  if raw then
    return raw=="true"
  end
  return default
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

-- extra added method
local function trim(text)
  return text:match("^%s*(.-)%s*$")
end
function test_api.settings:parse_setting_line(line, line_number, filename)
  ln = trim(line)
  if ln[1]=='#' then
    return
  end
  
  local is, ie = ln:find("=")
  
  if is then
    local key = trim(ln:sub(1,is-1))
    local value = trim(ln:sub(ie+1, -1))
    
    self.keys[key] = value
  else
    error("Bad line "..tostring(line_number).." in file `"..filename.."`.")
  end
end
function test_api.settings:load_from_file(filename)
  local file = io.open(filename, "r")
  if file then
    local line = file:read("*line")
    local line_number = 1
    while line do
      self:parse_setting_line(line, line_number, file_name)
      line = file:read("*line")
      line_number = line_number + 1
    end
    file:close()
  end
end

minetest.settings = Settings(nil)

