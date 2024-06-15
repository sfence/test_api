-- interactions

function test_api.punch_node(pos, puncher)
end

function test_api.move_itemstack(src_inv, src_list, src_index, dst_inv, dst_list, dst_index, stack, player)
  local src_allow = src_inv:allow_inventory_take(src_list, src_index, stack, player)
  if src_allow == 0 then
    print("Takes not allowed.")
    return
  end
  if (src_allow > 0) and (src_allow < stack:get_count()) then
    stack:set_count(src_allow)
  end
  local dst_allow = dst_inv:allow_inventory_put(dst_list, dst_index, stack, player)
  if dst_allow == 0 then
    print("Puts not allowed.")
    return
  end
  if (dst_allow > 0) and (dst_allow < stack:get_count()) then
    stack:set_count(dst_allow)
  end
  if (src_allow > 0) and (dst_allow > 0) then
    -- take items from stack
    local change = src_inv:get_stack(src_list, src_index)
    change:take_item(stack:get_count())
    src_inv:set_stack(src_list, src_index, change)
  end
  if dst_allow > 0 then
    -- put items to stack
    local change = dst_inv:get_stack(dst_list, dst_index)
    if change:add_item(stack):get_count() ~= 0 then
      error "[test_api] Function move_itemstack failed."
    end
    dst_inv:set_stack(dst_list, dst_index, change)
  end
  src_inv:on_inventory_take(src_list, src_index, stack, player)
  dst_inv:on_inventory_put(dst_list, dst_index, stack, player)
end

