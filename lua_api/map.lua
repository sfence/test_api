

function minetest.set_node(pos, node)
  test_api.set_node(pos, node, true)
end

function minetest.get_node(pos)
  return test_api.get_node(pos)
end

function minetest.swap_node(pos, node)
  return test_api.swap_node(pos, node)
end

function minetest.get_meta(pos)
  return test_api.get_meta(pos)
end

function minetest.get_node_timer(pos)
  return test_api.get_node_timer(pos)
end
