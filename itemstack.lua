
test_api.itemstack = {}

function ItemStack(x)
  return test_api.itemstack:new(x)
end

function test_api.itemstack:new(item)
  local new_itemstack = {fields = {}}
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
  return self.meta
end

function test_api.itemstack:get_description()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:get_short_description()
  error("[test_api]: Method is not implemented.")
end

function test_api.itemstack:clear()
  self.name = ""
  self.count = 0
  self.definition = nil
end
function test_api.itemstack:replace(item)
  error("[test_api]: Method is not implemented.")
end

function test_api.itemstack:to_string()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:to_table()
  error("[test_api]: Method is not implemented.")
end

function test_api.itemstack:get_stack_max()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:get_free_space()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:is_known()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:get_definition()
  return self.definition or minetest.registered_items[self.name]
end
function test_api.itemstack:get_tool_capabilities()
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:add_wear(amount)
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:add_wear_by_uses(maxuses)
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:add_item(item)
  error("[test_api]: Method is not implemented.")
end
function test_api.itemstack:items_fits(item)
  error("[test_api]: Method is not implemented.")
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
    self.count = 1
  else
    -- TODO: support for other parts of item string
    self.name = string.sub(text, 1, sep)
    self.count = tonumber(string.sub(text, sep, -1))
  end
end
