
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
      inventory = {},
    }
  for listname, listdata in pairs(self.node_inventory_table) do
    new_table.inventory[listname] = table.copy(listdata.stacks)
  end
  return new_table
end
function test_api.meta:from_table(data)
  for key, _ in pairs(self.fields) do
    self.fields[key] = nil
  end
  for key, value in pairs(data.fields) do
    self.fields[key] = value
  end
  for listname, _ in pairs(self.inventory) do
    self.inventory[listname] = nil
  end
  for listname, stacks in pairs(data.inventory) do
    self.inventory[listname] = {
      stacks = table.copy(stacks),
    }
  end
end

function test_api.meta:equals(other)
  print(dump(self:to_table()))
  print(dump(other:to_table()))
  error "[test_api] Meta equals not implemented."
  return false
end

-- Extra for node metadata
function test_api.meta:get_inventory()
  if self.node_pos then
    local inv = test_api.inventory:new()
    inv:attach_node_meta(self)
    return inv
  elseif self.player_name then
    local inv = test_api.inventory:new()
    inv:attach_player_meta(self)
    return inv
  else
    error "[test_api] Inventory manipulation is not implemented."
    return nil
  end
end

function test_api.meta:mark_as_private(namea)
  -- nothing have to be done here now
  -- this only disable sending of some metadata from server to client
  if (not self.node_pos) then
    error "[test_api] Callback mark_as_private is not defined for non-node metadata and should not be called."
  end
end

-- Extra for ItemStack metadata
function test_api.meta:set_tool_capabilities(namea)
  if self.itemstack_meta then
    error "[test_api] Callback set_tool_capabilities is not defined."
  else
    error "[test_api] Callback set_tool_capabilities is not defined for non-ItemStack metadata and should not be called."
  end
end

-- NON STANDARD TEST API ONLY METHODS
function test_api.meta:attach_node_meta(node_meta_table, node_inventory_table, node_pos)
  self.fields = node_meta_table
  self.inventory = node_inventory_table
  self.node_pos = node_pos
end
function test_api.meta:attach_itemstack_meta(itemstack_meta_table)
  self.fields = itemstack_meta_table
  self.itemstack_meta = true
end
function test_api.meta:attach_player_meta(player_meta_table, player_inventory_table, player_name)
  self.fields = player_meta_table
  self.inventory = player_inventory_table
  self.player_name = player_name
end

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

