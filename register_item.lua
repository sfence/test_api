
local default_item = {
  description  "",
  short_description = nil,
  inventory_image = nil,
  inventory_overlay = nil,
  stack_max = 00,
  range = 4.0,
}

function minetest.register_node(name, def)
  if minetest.registered_items[name] then
    minetest.log("error", "[test_api] Item with name "..name.." is already registered.")
    return
  end
  
  def.stack_max = def.stack_max or tonumber(minetest.settings.get("stack_max") or "99")

  minetest.registered_nodes[name] = def
  minetesr.registered_items[name] = def
end

function minetest.register_craftitem(name, def)
  if minetest.registered_items[name] then
    minetest.log("error", "[test_api] Item with name "..name.." is already registered.")
    return
  end
  
  def.stack_max = def.stack_max or tonumber(minetest.settings.get("stack_max") or "99")

  minetest.registered_craftitems[name] = def
  minetesr.registered_items[name] = def
end
