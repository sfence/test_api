-- this should emulate map

test_api.map_blocks = {}
local map_blocks = test_api.map_blocks

local BLOCK_SIZE = test_api.BLOCK_SIZE

-- use node_pos hash as key in map field to access node data

-- block_data:
--[[
  {
    active = false,
    map = {},
  }
--]]

-- node_data:
--[[
  {
    name = "",
    param = 0,
    param2 = 0,
    meta = {
      -- table of metadata from lua_api emulation
    }
    timer = {
      timeout_time = ,
      elapsed_time = ,
    }
  }
--]]


-- BASIC NODE ACCESS API
local function block_to_string(pos)
  return minetest.pos_to_string(vector.floor(vector.divide(pos,BLOCK_SIZE)))
end

local function get_pos_hashes(pos)
  local block_hash = minetest.hash_node_position(vector.floor(vector.divide(pos,BLOCK_SIZE)))
  local pos_hash = minetest.hash_node_position(pos)
  return block_hash, pos_hash
end
local function get_pos_map(pos)
  local block_hash, pos_hash = get_pos_hashes(pos)
  local block_data = map_blocks[block_hash]
  if (not block_data) then
    return nil, pos_hash
  end
  return block_data.map, pos_hash
end

function test_api.set_node(pos, node, call_node_func)
  local block_map, pos_hash = get_pos_map(pos)
  if (not block_map) then
    error("[test_api]: Block "..block_to_string(pos).." is not available for set node to position "..minetest.pos_to_string(pos)..".")
  end
  local node_def = minetest.registered_nodes[node.name]
  if (not node_def) then
    error("[test_api]: Unknown node "..node.name.." cannot be placed to the map on position "..minetest.pos_to_string(pos)..".")
  end
  
  local old_node, old_def
  if call_node_func then
    old_node = block_map[pos_hash]
    if old_node then
      old_def = minetest.registered_nodes[old_node.name]
      if old_def then
        if old_def.on_destruct then
          old_def.on_destruct(pos)
        end
      end
    else
      minetest.log("error", "[test_api]: Set_node overwrite unsetted node at position "..minetest_pos_to_string(pos).." with call_node_func enabled.")
    end 
  end
  
  block_map[pos_hash] = {
    name = node.name,
    param = node.param or 0,
    param2 = node.param2 or 0
  }
  
  if call_node_func then
    if old_def and old_def.after_destruct then
      old_def.after_destruct(pos, old_node)
    end
    if node_def.on_construct then
      node_def.on_construct(pos)
    end
  end
end
function test_api.swap_node(pos, node)
  local block_map, pos_hash = get_pos_map(pos)
  if (not block_map) then
    error("[test_api]: Block "..block_to_string(pos).." is not available.")
  end
  local node_def = minetest.registered_nodes[node.name]
  if (not node_def) then
    error("[test_api]: Unknown node "..node.name.." cannot be placed to the map on position "..minetest.pos_to_string(pos)..".")
  end
  local node_data = block_map[pos_hash]
    
  if (not node_data) then
    minetest.log("error", "[test_api]: Swap_node overwrite unsetted node at position "..minetest_pos_to_string(pos)..".")
    node_data = {}
    block_map[pos_hash] = node_data
  end
  
  -- only update node name, param and param2
  node_data.name = node.name
  node_data.param = node.param or 0
  node_data.param2 = node.param2 or 0
end

function test_api.get_node_or_nil(pos)
  local block_map, pos_hash = get_pos_map(pos)
  if block_map then
    local data = block_map[pos_hash]
    if (not data) then
      error("[test_api]: Unsetted node cannot be accessed in existing map block "..block_to_string(pos).." on position "..minetest.pos_to_string(pos)..".")
    end
    return {
        name = data.name,
        param = data.param,
        param2 = data.param2,
      }
  end
  return nil
end
function test_api.get_node(pos)
  local node = test_api.get_node_or_nil(pos)
  if not node then
    node = {
        name = "ignore",
        param = 0,
        param2 = 0,
      }
  end
  return node
end

function test_api.get_meta(pos)
  local block_map, pos_hash = get_pos_map(pos)
  if block_map then
    local data = block_map[pos_hash]
    if (not data) then
      error("[test_api]: Unsetted node cannot be accessed in existing map block "..block_to_string(pos).." on position "..minetest.pos_to_string(pos)..".")
    end
    local meta = test_api.meta:new()
    data.meta = data.meta or {
        fields = {},
        inventory = {
            lists = {},
            callbacks = {},
          },
      }
    meta:attach_node_meta(data.meta.fields, data.meta.inventory, table.copy(pos))
    return meta
  end
  return nil
end

function test_api.get_node_timer(pos)
  local block_map, pos_hash = get_pos_map(pos)
  if block_map then
    local data = block_map[pos_hash]
    if (not data) then
      error("[test_api]: Unsetted node cannot be accessed in existing map block "..block_to_string(pos).." on position "..minetest.pos_to_string(pos)..".")
    end
    data.timer = data.timer or {
        timeout_time = 0,
        elapsed_time = 0,
      }
    local timer = test_api.NodeTimerRef:new(table.copy(pos), data.timer)
    return timer
  end
  return nil
end

-- BASIC BLOCK ACCESS API

-- create if map block does not exists and fill it by node
function test_api.fill_map_block(pos, node, call_node_func)
  local block_hash, pos_hash = get_pos_hashes(pos)
  local map_block = map_blocks[block_hash] or {
      active = false,
      map = {}
    }
  map_blocks[block_hash] = map_block
  -- pos to block offset pos
  pos = vector.multiply(vector.floor(vector.divide(pos, BLOCK_SIZE)), BLOCK_SIZE)
  local x, y, z;
  for z=0,BLOCK_SIZE-1 do
    for y=0,BLOCK_SIZE-1 do
      for x=0,BLOCK_SIZE-1 do
        local set_pos = vector.new(x, y, z)
        set_pos = vector.add(pos, set_pos)
        test_api.set_node(set_pos, node, call_node_func)
      end 
    end
  end
end

function test_api.fill_area_by_node(pos1, pos2, node, call_node_func)
  assert(pos1.x<=pos2.x, "[test_api]: pos2.x cannot be lower than pos1.x")
  assert(pos1.y<=pos2.y, "[test_api]: pos2.y cannot be lower than pos1.y")
  assert(pos1.z<=pos2.z, "[test_api]: pos2.z cannot be lower than pos1.z")
  for z=pos1.z,pos2.z do
    for y=pos1.y,pos2.y do
      for x=pos1.x,pos2.x do
        local set_pos = vector.new(x, y, z)
          
        local block_hash, pos_hash = get_pos_hashes(pos)
        local map_block = map_blocks[block_hash] or {
            active = false,
            map = {}
          }
        map_blocks[block_hash] = map_block
        
        test_api.set_node(set_pos, node, call_node_func)
      end
    end
  end
end

function test_api.active_map_block(pos, active)
  local block_hash, pos_hash = get_pos_hashes(pos)
  local map_block = map_blocks[block_hash]
  if map_block then
    if (active==nil) then
      active = true
    end
    map_block.active = active
  end
end

-- DEBUGGING API

function test_api.debug_map_blocks()
  for block_hash, _ in pairs(test_api.map_blocks) do
    print("block_hash: "..block_hash)
  end
end

function test_api.debug_node(pos)
  print("node_pos: "..minetest.pos_to_string(pos).." in block: "..block_to_string(pos))
  local block_hash, pos_hash = get_pos_hashes(pos)
  print("block_hash: "..block_hash.." pos_hash: "..pos_hash)
  local block_map, pos_hash = get_pos_map(pos)
  if block_map then
    local data = block_map[pos_hash]
    if data then
      print("Node name: "..data.name.." param1: "..data.param.." param2: "..data.param2)
      print("Dumped data: "..dump(data))
    else
      print("Node in not set.")
    end
  else
   print("No block map data.")
  end
end
