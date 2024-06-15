
test_api.LuaEntityRef = {}

setmetatable(test_api.LuaEntityRef, {__index = test_api.ObjectRef})

function test_api.LuaEntityRef:new()
  local new_entity = {}
  setmetatable(new_entity, {__index = self})
  return new_entity
end

function test_api.LuaEntityRef:remove()
end
function test_api.LuaEntityRef:set_velocity()
end
function test_api.LuaEntityRef:set_acceleration()
end
function test_api.LuaEntityRef:set_rotation()
end
function test_api.LuaEntityRef:get_rotation()
end
function test_api.LuaEntityRef:set_yaw()
end
function test_api.LuaEntityRef:get_yaw()
end
function test_api.LuaEntityRef:set_texture_mod()
end
function test_api.LuaEntityRef:get_texture_mod()
end
function test_api.LuaEntityRef:get_entity_name()
end
function test_api.LuaEntityRef:get_luaentity()
end

-- extra methods added by test_api
--[[
function test_api.LuaEntityRef:()
end
function test_api.LuaEntityRef:()
end
function test_api.LuaEntityRef:()
end
function test_api.LuaEntityRef:()
end
--]]

