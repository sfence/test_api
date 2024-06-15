
local BLOCK_SIZE = test_api.BLOCK_SIZE

function test_api.world_step(timediff)
  test_api.process_active_blocks(timediff)
end

function test_api.process_active_blocks(timediff)
  for block_hash, map_block in pairs(test_api.map_blocks) do
    if map_block.active then
      local pos_offset = vector. multiply(minetest.get_position_from_hash(block_hash), BLOCK_SIZE)
      test_api.process_timers(map_block, pos_offset, timediff)
    end
  end
end

function test_api.process_timers(map_block, pos_offset, timediff)
  for pos_hash, node in pairs(map_block.map) do
    if node.timer and (node.timer.timeout_time>0) then
      --print("Node with active timer found.")
      node.timer.elapsed_time = node.timer.elapsed_time + timediff
      if node.timer.elapsed_time>node.timer.timeout_time then
        local timeout_time = node.timer.timeout_time
        node.timer.timeout_time = 0
        local node_def = minetest.registered_nodes[node.name]
        if node_def and node_def.on_timer then
          --print("on_timer called for "..node.name)
          if node_def.on_timer(minetest.get_position_from_hash(pos_hash), node.timer.elapsed_time) then
            node.timer.timeout_time = timeout_time
            node.timer.elapsed_time = 0
          end
        else
          error("[test_api] NodeTimer run over node \""..node.name.."\" without on_timer callback.")
        end
      end
    end
  end
end

function test_api.process_abms(map_block, pos_offset)
end

function test_api.process_lbms(map_block, pos_offset)
end

function test_api.process_nodes(map_block, pos_offset)
end

function test_api.process_entities(map_block, pos_offset)
end

