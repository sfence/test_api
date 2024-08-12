
test_api.inventory = {}

function test_api.inventory:new()
  local new_inv = {lists = {}}
  setmetatable(new_inv, {__index = self})
  return new_inv
end

local function get_stack_object(stack)
  if type(stack)=="string" then
    return test_api.itemstack:new(stack)
  end
  return stack
end

function test_api.inventory:is_empty(listname)
  if self.lists[listname] then
    local list = self.lists[listname]
    for _, stack in pairs(list.stacks) do
      if (stack~="") then
        return true
      end
    end
    return false
  end
  return true
end
function test_api.inventory:get_size(listname)
  if self.lists[listname] then
    return #self.lists[listname].stacks
  end
  return 0
end
function test_api.inventory:set_size(listname, size)
  if (size>0) then
    local list = self.lists[listname] or {
        stacks = {},
        width = 0,
      }
    local stacks = {}
    for i=1,size do
      stacks[i] = list.stacks[i] or ""
    end
    list.stacks = stacks
    self.lists[listname] = list
  else
    self.lists[listname] = nil
  end
end
function test_api.inventory:get_width(listname)
  if self.lists[listname] then
    return self.lists[listname].width
  end
  return 0
end
function test_api.inventory:set_width(listname, width)
  if self.lists[listname] then
    self.lists[listname].width = width
  end
end
function test_api.inventory:get_stack(listname, i)
  if self.lists[listname] then
    local list = self.lists[listname]
    if list.stacks[i] then
      local stack = test_api.itemstack:new(list.stacks[i])
      return stack
    end
  end
end

function test_api.inventory:set_stack(listname, i, stack)
  if self.lists[listname] then
    local list = self.lists[listname]
    if list.stacks[i] then
      list.stacks[i] = stack:to_string()
    end
  end
end
function test_api.inventory:get_list(listname)
  return table.copy(self.lists[listname].stacks)
end
function test_api.inventory:set_list(listname, list)
  error("[test_api]: Method is not implemented.")
end
function test_api.inventory:get_lists()
  local lists = {}
  for listname, list in pairs(self.lists) do
    lists[listname] = table.copy(list.stacks)
  end
end
function test_api.inventory:set_lists(lists)
  error("[test_api]: Method is not implemented.")
end
function test_api.inventory:add_item(listname, stack)
  stack = ItemStack(stack)
  if self.lists[listname] then
    local list = self.lists[listname]
    for _, inv_stack in pairs(list.stacks) do
      inv_stack = test_api.itemstack:new(inv_stack)
      print(inv_stack:to_string())
      if inv_stack:same_item(stack, true) or (inv_stack:get_count()==0) then
        local free = inv_stack:get_free_space()
        if free > 0 then
          stack = inv_stack:add_item(stack)
        end
      end
    end
  end
  return stack
end
function test_api.inventory:room_for_item(listname, stack)
  stack = get_stack_object(stack)
  local items = stack:get_count()
  if self.lists[listname] then
    local list = self.lists[listname]
    for _, inv_stack in pairs(list.stacks) do
      inv_stack = test_api.itemstack:new(inv_stack)
      if inv_stack:same_item(stack, true) then
        items = math.max(items - inv_stack:get_free_space(), 0)
      end
    end
  end
  return items == 0
end
function test_api.inventory:contains_item(listname, stack, match_meta)
  error("[test_api]: Method is not implemented.")
end
function test_api.inventory:remove_item(listname, stack)
  stack = ItemStack(stack)
  local remove_count = stack:get_count()
  local removed_count = 0
  if self.lists[listname] then
    local list = self.lists[listname]
    for _, inv_stack in pairs(list.stacks) do
      inv_stack = test_api.itemstack:new(inv_stack)
      if inv_stack:same_item(stack, false) then
        local count = math.min(inv_stack:get_count(), remove_count)
        if count > 0 then
          remove_count = remove_count - count
          removed_count = removed_count + count
        end
      end
    end
  end
  stack:set_count(removed_count)
  return stack
end
function test_api.inventory:get_location()
  return self._location or {
    type = "undefined",
  }
end

-- NON STANDARD TEST API ONLY METHODS
function test_api.inventory:attach_node_meta(meta)
  self.lists = meta.inventory.lists
  self.callbacks = meta.inventory.callbacks
  self._location = {
      type = "node",
      pos = table.copy(meta.node_pos),
    }
end
function test_api.inventory:attach_player_meta(meta)
  self.lists = meta.inventory.lists
  self.callbacks = meta.inventory.callbacks
  self._location = {
      type = "player",
      player = meta.player_name.."",
    }
end

function test_api.inventory:allow_inventory_take(list, index, stack, player)
  if self._location.type == "node" then
    if self.callbacks.allow_inventory_take then
      return self.callbacks.allow_inventory_take(self._location.pos, list, index, stack, player)
    else
      local node = minetest.get_node(self._location.pos)
      if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].allow_metadata_inventory_take then
        return minetest.registered_nodes[node.name].allow_metadata_inventory_take(self._location.pos, list, index, stack, player)
      else
        return stack:get_count()
      end
    end
  elseif self._location.type == "player" then
    if self.callbacks.allow_inventory_take then
      return self.callbacks.allow_inventory_take(self, list, index, stack, player)
    else
      return stack:get_count()
    end
  end
  return 0
end

function test_api.inventory:allow_inventory_put(list, index, stack, player)
  if self._location.type == "node" then
    if self.callbacks.allow_inventory_put then
      return self.callbacks.allow_inventory_put(self._location.pos, list, index, stack, player)
    else
      local node = minetest.get_node(self._location.pos)
      if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].allow_metadata_inventory_put then
        return minetest.registered_nodes[node.name].allow_metadata_inventory_put(self._location.pos, list, index, stack, player)
      else
        local tstack = self:get_stack(list, index)
        return math.max(tstack:get_stack_max() - tstack:get_count(), 0)
      end
    end
  elseif self._location.type == "player" then
    if self.callbacks.allow_inventory_put then
      return self.callbacks.allow_inventory_put(self, list, index, stack, player)
    else
      local tstack = self:get_stack(list, index)
      return math.max(tstack:get_stack_max() - tstack:get_count(), 0)
    end
  end
  return 0
end

function test_api.inventory:on_inventory_take(list, index, stack, player)
  if self._location.type == "node" then
    if self.callbacks.on_inventory_take then
      self.callbacks.on_inventory_take(self._location.pos, list, index, stack, player)
    else
      local node = minetest.get_node(self._location.pos)
      if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_metadata_inventory_take then
        return minetest.registered_nodes[node.name].on_metadata_inventory_take(self._location.pos, list, index, stack, player)
      end
    end
  elseif self._location.type == "player" then
    if self.callbacks.on_inventory_take then
      self.callbacks.on_inventory_take(self, list, index, stack, player)
    end
  end
end

function test_api.inventory:on_inventory_put(list, index, stack, player)
  if self._location.type == "node" then
    if self.callbacks.on_inventory_put then
      self.callbacks.on_inventory_put(self._location.pos, list, index, stack, player)
    else
      local node = minetest.get_node(self._location.pos)
      if node and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_metadata_inventory_put then
        return minetest.registered_nodes[node.name].on_metadata_inventory_put(self._location.pos, list, index, stack, player)
      end
    end
  elseif self._location.type == "player" then
    if self.callbacks.on_inventory_put then
      self.callbacks.on_inventory_put(self, list, index, stack, player)
    end
  end
end

