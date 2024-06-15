
test_api.itemstack = {}

function ItemStack(x)
  return test_api.itemstack:new(x)
end

function test_api.itemstack:new(item)
  local new_itemstack = {}
  setmetatable(new_itemstack, {__index = self})
  if type(item)=="string" then
    new_itemstack:from_string(item)
  elseif type(item)=="table" then
    new_itemstack.name = item.name
    new_itemstack.count = item.count
    new_itemstack.wear = item.wear
    new_itemstack.definition = item.definition
    if item.meta then
      new_itemstack.meta = table.copy(item.meta)
    end
  end
  return new_itemstack
end

test_api.itemstack.name = ""
test_api.itemstack.count = 0
test_api.itemstack.wear = 0
test_api.itemstack.meta = {}

function test_api.itemstack:is_empty()
  return (self.count==0)
end

function test_api.itemstack:get_name()
  return self.name
end
function test_api.itemstack:set_name(name)
  -- TODO: check if count has to be set to 1?
  self.name = name
end

function test_api.itemstack:get_count()
  return self.count
end
function test_api.itemstack:set_count(count)
  self.count = count
end

function test_api.itemstack:get_wear()
  return self.wear
end
function test_api.itemstack:set_wear(wear)
  -- TODO: some check if this is relevant action for this kind of item?
  self.wear = wear
end

function test_api.itemstack:get_meta()
  local meta = test_api.meta:new()
  meta:attach_itemstack_meta(self.meta)
  return meta
end

function test_api.itemstack:get_description()
  if self.meta and self.meta["description"] then
    return self.meta["description"]
  end
  local definition = self.definition or minetest.registered_items[self.name]
  return definition.description or self.name
end
function test_api.itemstack:get_short_description()
  if self.meta and self.meta["short_description"] then
    return self.meta["short_description"]
  end
  local definition = self.definition or minetest.registered_items[self.name]
  if definition.short_description then
    return definition.short_description
  end
  local description = nil
  if self.meta and self.meta["description"] then
    description = self.meta["description"]
  end
  description = description or definition.description
  if description then
    local sep = string.find(description, "\n") or -1
    return string.sub(description, 1, sep)
  end
  return nil
end

function test_api.itemstack:clear()
  self.name = ""
  self.count = 0
  self.definition = nil
end
function test_api.itemstack:replace(item)
  error("[test_api]: Method is not implemented.")
  self:clear()
end

function test_api.itemstack:get_stack_max()
  local definition = self.definition or minetest.registered_items[self.name]
  return definition.stack_max
end
function test_api.itemstack:get_free_space()
  local definition = self.definition or minetest.registered_items[self.name]
  return math.max(definition.stack_max-self.count, 0)
end
function test_api.itemstack:is_known()
  --local definition = self.definition or minetest.registered_items[self.name]
  --if definition then
  if minetest.registered_items[self.name] then
    return true
  end
  return false
end
function test_api.itemstack:get_definition()
  return self.definition or minetest.registered_items[self.name]
end
function test_api.itemstack:get_tool_capabilities()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:add_wear(amount)
  local definition = self.definition or minetest.registered_items[self.name]
  if (definition.type=="tool") then
    self.wear = self.wear + amount
  end
end
function test_api.itemstack:add_wear_by_uses(maxuses)
  local definition = self.definition or minetest.registered_items[self.name]
  if (definition.type=="tool") and (maxuses>0) then
    self.wear = self.wear + math.floor(65536/maxuses)
  end
end
function test_api.itemstack:add_item(item)
  if (self.name=="") then
    if (type(item)=="string") then
      self:from_string(item)
    else
      self.name = item.name..""
      self.count = item.count
      self.wear = item.wear
      self.definition = item.definition
      if item.meta then
        self.meta = table.copy(item.meta)
      end
    end
    return test_api.itemstack:new("")
  end
  if (type(item)=="string") then
    item = test.api.itemstack:new(item)
  end
  if (self.name~=item.name) then
    return test_api.itemstack:new(item)
  end
  local definition = self.definition or minetest.registered_items[self.name]
  self.count = self.count + item.count
  local leftover = test_api.itemstack:new(item)
  leftover:set_count(math.max(self.count-definition.stack_max, 0))
  self.count = math.min(self.count, definition.stack_max)
  return leftover
end
function test_api.itemstack:item_fits(item)
  if (self.name=="") then return true end
  if (type(item)=="string") then
    item = test.api.itemstack:new(item)
  end
  if (self.name~=item.name) then return false end
  
  local definition = self.definition or minetest.registered_items[self.name]
  if (not definition) then return false end
  if ((self.count+item.count)<=definition.stack_max) then return true end
  return false
end
function test_api.itemstack:take_item(n)
  n = n or 1
  if n > self.count then
    n = self.count
  end
  local taken = ItemStack(self)
  self.count = self.count - n
  taken:set_count(n)
  return taken
end
function test_api.itemstack:peek_item(n)
  n = n or 1
  if n > self.count then
    n = self.count
  end
  local taken = ItemStack(self)
  taken:set_count(n)
  return taken
end

function test_api.itemstack:to_string()
  local itemstring = ""..self.name.." "..self.count.." "..self.wear
  if self.meta and (#self.meta>0) then
    itemstring = itemstring.."\u{0001}"
    for key, value in self.meta do
      itemstring = itemstring..key.."\u{0002}"..value.."\u{0003}"
    end
  end
  return itemstring
end
function test_api.itemstack:to_table()
  error("[test_api]: Method is not implemented.")
end

-- special test api added methods

function test_api.itemstack:set_definition(definition)
  self.definition = definition
end

function test_api.itemstack:from_string(text)
  local sep = string.find(text, " ")
  if sep==nil then
    self.name = text
    if text=="" then
      self.count = 0
    else
      self.count = 1
    end
    self.wear = 0
  else
    self.name = string.sub(text, 1, sep - 1)
    text = string.sub(text, sep + 1, -1)
    sep = string.find(text, " ")
    if sep then
      self.count = tonumber(string.sub(text, 1, sep - 1))
      text = string.sub(text, sep + 1, -1)
      sep = string.find(text, "\u{0001}")
      if sep then
        self.wear = tonumber(string.sub(text, 1, sep - 1))
        self.meta = {}
        while true do
          sep = string.find(text, "\u{0002}")
          if (not sep) then break end
          local key = string.sub(text, 1, sep - 1)
          text = string.sub(text, sep + 1, -1)
          sep = string.find(text, "\u{0003}")
          if (not sep) then break end
          self.meta[key] = string.sub(text, 1, sep - 1)
          text = string.sub(text, sep + 1, -1)
        end
      else
        self.wear = tonumber(text)
      end
    else
      self.count = tonumber(text)
      self.wear = 0
    end
  end
end

function test_api.itemstack:same_item(item, check_meta)
  if (self.name ~= item.name) then return false end
  if (self.wear ~= item.wear) then return false end
  if check_meta then
    if (self:have_meta() and item:have_meta()) then
      local meta = self:get_meta()
      if (not meta:equals(item:get_meta())) then return false end
    elseif (self:have_meta() or item:have_meta()) then
      return false
    end
  end
  return true
end
function test_api.itemstack:have_meta()
  if self.meta and #self.meta > 0 then
    return true
  end
  return false
end
