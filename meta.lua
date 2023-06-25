
test_api.meta = {}

function test_api.meta:new()
  local new_meta = {fields = {}}
  setmetatable(new_meta, {__index = self})
  return new_meta
end

function test_api.meta:contains(key)
  return (self.fields[key]~=nil)
end

function test_api.meta:get(key)
  return self.fields[key]
end

function test_api.meta:set_string(key, value)
  if value=="" then
    self.fields[key] = nil
  else
    self.fields[key] = tostring(value)
  end
end
function test_api.meta:get_string(key)
  return self.fields[key] or ""
end

function test_api.meta:set_int(key, value)
  self.fields[key] = math.floor(tonumber(value))
end
function test_api.meta:get_int(key)
  return math.floor(tonumber(self.fields[key] or "0"))
end

function test_api.meta:set_float(key, value)
  self.fields[key] = tonumber(value)
end
function test_api.meta:get_float(key)
  return tonumber(self.fields[key] or "0")
end

function test_api.meta:to_table()
  local new_table = {
      fields = table.copy(self.fields),
    }
end
function test_api.meta:from_table(data)
  self.fileds = table.copy(data.fields or {})
end

function test_api.meta:equals(other)
  error "[test_api] Meta equals not implemented."
  return false
end

-- NON STANDARD TEST ONLY METHODS

function test_api.meta:get_ints(graph_structure, graph_name)
  local data = {}
  for _,key in pairs(graph_structure[graph_name]) do
    data[graph_name][key] = math.floor(tonumber(self.fields[key] or "0"))
  end
  return data
end
function test_api.meta:insert_ints(graph_structure, graph_name, data, index)
  for _,key in pairs(graph_structure[graph_name]) do
    data[graph_name][key][index] = math.floor(tonumber(self.fields[key] or "0"))
  end
end

function test_api.meta:get_floats(graph_structure, graph_name)
  local data = {}
  for _,key in pairs(graph_structure[graph_name]) do
    data[graph_name][key] = tonumber(self.fields[key] or "0")
  end
  return data
end
function test_api.meta:insert_floats(graph_structure, graph_name, data, index)
  for _,key in pairs(graph_structure[graph_name]) do
    data[graph_name][key][index] = tonumber(self.fields[key] or "0")
  end
end

