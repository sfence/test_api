
test_api.ObjectRef = {}

function test_api.ObjectRef:new(def)
  local new_ref = def or {}
  for key, value in pairs(self) do
    if (type(value)~="function") and (new_ref[key]==nil) then
      if (type(value)=="table") then
        new_ref[key] = table.copy(value)
      else
        new_ref[key] = value
      end
    end
  end
  setmetatable(new_ref, {__index = self})
  return new_ref
end

test_api.ObjectRef._pos = vector.new(0,0,0)
test_api.ObjectRef._velocity = vector.new(0,0,0)
test_api.ObjectRef._hp = 1

function test_api.ObjectRef:get_pos()
  return self._pos
end
function test_api.ObjectRef:set_pos(pos)
  if type(pos)=="table" then
    self._pos = pos
  end
end
function test_api.ObjectRef:get_velocity()
  return self._velocity
end
function test_api.ObjectRef:add_velocity(val)
  self._velocity = vector.add(self._velocity, val)
end
function test_api.ObjectRef:move_to(pos, continuous)
  self:set_pos(pos)
end
function test_api.ObjectRef:punch(puncher, time_from_last_punch, tool_capabilities, direction)
end
function test_api.ObjectRef:right_click(clicker)
end
function test_api.ObjectRef:get_hp()
  return self._hp
end
function test_api.ObjectRef:set_hp(hp, reason)
  self._hp = hp
end
function test_api.ObjectRef:get_inventory()
  return nil
end
function test_api.ObjectRef:get_wield_list()
end
function test_api.ObjectRef:get_wield_index()
end
function test_api.ObjectRef:get_wielded_item()
  return nil
end
function test_api.ObjectRef:set_wielded_item(item)
end
function test_api.ObjectRef:set_armor_groups(armor_groups)
end
function test_api.ObjectRef:get_armor_groups()
end
function test_api.ObjectRef:set_animation(frame_range, frame_speed, frame_blend, frame_loop)
  self._frame_range = frame_range
  self._frame_speed = frame_speed
  self._frame_blend = frame_blend
  self._frame_loop = frame_loop
end
function test_api.ObjectRef:get_animation()
  return self._frame_range, self._frame_speed, self._frame_blend, self._frame_loop
end
function test_api.ObjectRef:set_animation_frame_speed(frame_speed)
  self,_frame_speed = frame_speed
end
function test_api.ObjectRef:set_attach(parent, bone, position, rotation, forced_visible)
end
function test_api.ObjectRef:get_attach()
end
function test_api.ObjectRef:get_children()
end
function test_api.ObjectRef:set_detach()
end
function test_api.ObjectRef:set_bone_position(bone, position, rotation)
  self._bones[bone] = {
      position = position,
      rotation = rotation
    }
end
function test_api.ObjectRef:get_bone_position(bone)
  if self._bones[bone] then
    return self._bones[bone].position, self._bones[bone].rotation
  end
end
function test_api.ObjectRef:set_properties(properties_table)
end
function test_api.ObjectRef:get_properties()
end
function test_api.ObjectRef:is_player()
  return false
end
function test_api.ObjectRef:get_nametag_attributes()
end
function test_api.ObjectRef:set_nametag_attributes(attributes)
end

-- extra functions added by test_api
--[[
function test_api.ObjectRef:()
end
--]]

