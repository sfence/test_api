
test_api.PlayerRef = {}

setmetatable(test_api.PlayerRef, {__index = test_api.LuaEntityRef})

function test_api.PlayerRef:new(def)
  local new_player = def or {}
  for key, value in pairs(self) do
    if (type(value)~="function") and (new_player[key]==nil) then
      if (type(value)=="table") then
        new_player[key] = table.copy(value)
      else
        new_player[key] = value
      end
    end
  end
  setmetatable(new_player, {__index = self})
  return new_player
end

local ALLOWED_PHYSICS_PARAMS = {
  speed = "number",
  jump = "number",
  gravity = "number",
  sneak = "boolean",
  sneak_glith = "boolean",
  new_move = "boolean",
}
local DEFAULT_PHYSICS_PARAMS = {
  speed = 1.0,
  jump = 1.0,
  gravity = 1.0,
  sneak = true,
  sneak_glith = false,
  new_move = true,
}
local ALLOWED_SKY_PARAMS = {
  base_color = test_api.check_ColorSpec,
  body_orbit_tilt = test_api.get_check_float_range(-60.0, 60.0),
  type = test_api.get_check_string_variants({"regular","skybox","plain"}),
  --textures = ,
  clouds = "boolean",
  sky_color = {
    day_sky = test_api.check_ColorSpec,
    day_horizon = test_api.check_ColorSpec,
    dawn_sky = test_api.check_ColorSpec,
    dawn_horizon = test_api.check_ColorSpec,
    night_sky = test_api.check_ColorSpec,
    night_horizon = test_api.check_ColorSpec,
    indoors = test_api.check_ColorSpec,
    fog_sun_tint = test_api.check_ColorSpec,
    fog_noon_tint = test_api.check_ColorSpec,
    fog_tint_type = test_api.get_check_string_variants({"default","custom"}),
  },
}
local DEFAULT_SKY_PARAMS = {
  base_color = 0xFFFFFF,
  body_orbit_tilt = nil,
  type = "regular",
  clouds = true,
  sky_color = {
    day_sky = "#61b5f5",
    day_horizon = "#90d3f6",
    dawn_sky = "#b4bafa",
    dawn_horizon = "#bac1f0",
    night_sky = "#006bff",
    night_horizon = "#4090ff",
    indoors = "#646464",
    fog_sun_tint = "#f47d1d",
    fog_noon_tint = "#7f99cc",
    fog_tint_type = "default",
  },
}
local ALLOWED_SUN_PARAMS = {
  visible = "boolean",
  texture = "string",
  tonemap = "string",
  sunrise = "string",
  sunrise_visible = "boolean",
  scale = "number",
}
local DEFAULT_SUN_PARAMS = {
  visible = true,
  texture = "sun.png",
  tonemap = "sun_tonemap.png",
  sunrise = "sunrisebd.png",
  sunrise_visible = true,
  scale = 1.0,
}
local ALLOWED_MOON_PARAMS = {
  visible = "boolean",
  texture = "string",
  tonemap = "string",
  scale = "number",
}
local DEFAULT_MOON_PARAMS = {
  visible = true,
  texture = "moon.png",
  tonemap = "moon_tonemap.png",
  scale = 1.0,
}
local ALLOWED_STARS_PARAMS = {
  visible = "boolean",
  day_opacity = test_api.get_check_float_range(0.0, 1.0),
  count = test_api.get_check_integer_range(0, nil),
  color = test_api.check_ColorSpec,
  scale = "number",
}
local DEFAULT_STARS_PARAMS = {
  visible = true,
  day_opacity = 0.0,
  count = 1000,
  color = "#ebebff69",
  scale = 1.0,
}
local ALLOWED_CLOUD_PARAMS = {
  density = test_api.get_check_float_range(0.0, 1.0),
  color = test_api.check_ColorSpec,
  ambient = test_api.check_ColorSpec,
  height = "number",
  thickness = test_api.get_check_float_range(0.0, nil),
  speed = {
    x = "number",
    z = "numebr",
  },
}
local DEFAULT_CLOUD_PARAMS = {
  density = 0.4,
  color = "#fff0f0e5",
  ambient = "#000000",
  height = 120,
  thickness = 16,
  speed = {
    x = 0,
    z = -2,
  },
}
local ALLOWED_PLAYER_CONTROL_PARAMS = {
  up = "boolean",
  down = "boolean",
  left = "boolean",
  right = "boolean",
  jump = "boolean",
  aux1 = "boolean",
  sneek = "boolean",
  dig = "boolean",
  place = "boolean",
  zoom = "boolean",
}
local DEFAULT_PLAYER_CONTROL_PARAMS = {
  up = false,
  down = false,
  left = false,
  right = false,
  jump = false,
  aux1 = false,
  sneek = false,
  dig = false,
  place = false,
  zoom = false,
}
local ALLOWED_LIGHTING_PARAMS = {
  saturation = "number",
  shadows = {
    intensity = test_api.get_check_float_range(0.0, 1.0),
  },
  exposure = {
    luminance_min = "number",
    luminance_max = "number",
    exposure_correction = "number",
    speed_dark_bright = "number",
    speed_bright_dark = "number",
    center_weight_power = "number",
  },
}
local DEFAULT_LIGHTING_PARAMS = {
  saturation = 1.0,
  shadows = {
    intensity = 0.0,
  },
  exposure = {
    luminance_min = -3.0,
    luminance_max = -3.0,
    exposure_correction = 0.0,
    speed_dark_bright = 1000.0,
    speed_bright_dark = 1000.0,
    center_weight_power = 1.0,
  },
}

test_api.PlayerRef._physics = table.copy(DEFAULT_PHYSICS_PARAMS)
test_api.PlayerRef._sky_parameters = table.copy(DEFAULT_SKY_PARAMS)
test_api.PlayerRef._sun_parameters = table.copy(DEFAULT_SUN_PARAMS)
test_api.PlayerRef._moon_parameters = table.copy(DEFAULT_MOON_PARAMS)
test_api.PlayerRef._stars_parameters = table.copy(DEFAULT_STARS_PARAMS)
test_api.PlayerRef._cloud_parameters = table.copy(DEFAULT_CLOUD_PARAMS)
test_api.PlayerRef._player_control = table.copy(DEFAULT_PLAYER_CONTROL_PARAMS)
test_api.PlayerRef._lighting = table.copy(DEFAULT_LIGHTING_PARAMS)

function test_api.PlayerRef:get_player_name()
  return self._player_name
end
function test_api.PlayerRef:get_player_velocity()
  error "[test_api] Method get_player_velocity is depreaced and is not supported!"
end
function test_api.PlayerRef:add_player_velocity(vel)
  error "[test_api] Method add_player_velocity is depreaced and is not supported!"
end
function test_api.PlayerRef:get_look_dir()
  local pitch = self._look_vertical
  local yaw = self._look_horizontal
  return vector.new(math.cos(pitch)*math.cos(yaw),math.sin(pitch),math.cos(pitch)*math.sin(yaw))
end
function test_api.PlayerRef:get_look_vertical()
  return self._look_vertical
end
function test_api.PlayerRef:get_look_horizontal()
  return self._look_horizontal
end
function test_api.PlayerRef:set_look_vertical(radians)
  self._look_vertical = radians
end
function test_api.PlayerRef:set_look_horizontal(radians)
  self._look_horizontal = radians
end
function test_api.PlayerRef:get_look_pitch()
  error "[test_api] Method set_look_pitch is depreaced and is not supported!"
end
function test_api.PlayerRef:get_look_yaw()
  error "[test_api] Method set_look_yaw is depreaced and is not supported!"
end
function test_api.PlayerRef:set_look_pitch()
  error "[test_api] Method set_look_pitch is depreaced and is not supported!"
end
function test_api.PlayerRef:set_look_yaw()
  error "[test_api] Method set_look_yaw is depreaced and is not supported!"
end
function test_api.PlayerRef:get_breath()
  return self._breath
end
function test_api.PlayerRef:set_breath(value)
  self._breath = math.min(value, self._breath_max)
end
test_api.PlayerRef._fov = {
    fov = 0,
    target_fov = 0,
    multiplier = false,
    transition_time = 0,
  }
function test_api.PlayerRef:set_fov(fov, is_multiplier, transition_time)
  self._fov.target_fov = fov
  self._fov.multiplier = is_multiplier
  self._fov.transition_time = transition_time
end
function test_api.PlayerRef:get_fov()
  return self._fov.fov, self._fov.multiplier, self._fov.transition_time
end
function test_api.PlayerRef:set_attribute()
  error "[test_api] Method get_attribute is depreaced and is not supported!"
end
function test_api.PlayerRef:get_attribute()
  error "[test_api] Method set_attribute is depreaced and is not supported!"
end
test_api.PlayerRef._meta = {
    fields = {},
    inventory = {
        lists = {
          main = {
            width = 0,
            stacks = {"", "", "", "", "", "", "", "", "", "",
                      "", "", "", "", "", "", "", "", "", "",
                      "", "", "", "", "", "", "", "", "", "",
                      "", "", "", "", "", "", "", "", "", ""},
          },
        },
        callbacks = {},
      },
  }
function test_api.PlayerRef:get_meta()
  if not self._player_name then
    error "[test_api] Method get_mera cannot be used without set player_name."
  end
  local meta = test_api.meta:new()
  meta:attach_player_meta(self._meta.fields, self._meta.inventory, self._player_name)
  return meta
end
function test_api.PlayerRef:set_inventory_formspec(formspec)
  self._inventory_formspec = formspec
end
function test_api.PlayerRef:get_inventory_formspec()
  return self._inventory_formspec
end
function test_api.PlayerRef:set_formspec_predend(formspec)
  self._formspec_predend = formspec
end
function test_api.PlayerRef:get_formspec_predend()
  return self._formspec_predend
end
function test_api.PlayerRef:get_player_control()
  return table.copy(self._player_control)
end
function test_api.PlayerRef:get_player_control_bits()
  local bits = 0
  if self._player_control.up then bits = bits + 1; end
  if self._player_control.down then bits = bits + 2; end
  if self._player_control.left then bits = bits + 4; end
  if self._player_control.right then bits = bits + 8; end
  if self._player_control.jump then bits = bits + 16; end
  if self._player_control.aux1 then bits = bits + 32; end
  if self._player_control.sneek then bits = bits + 64; end
  if self._player_control.dig then bits = bits + 128; end
  if self._player_control.place then bits = bits + 256; end
  if self._player_control.zoom then bits = bits + 512; end
  return bits
end
function test_api.PlayerRef:set_physics_override(override_table)
  if (not test_api.check_table_of_parameters(override_table, ALLOWED_PHYSICS_PARAMS, false, false)) then
    error "[test_api] Calling of method set_physics_override with invalid override_table table."
  end
  self._physics = test_api.apply_table_of_parameters(override_table, DEFAULT_PHYSICS_PARAMS)
end
function test_api.PlayerRef:get_physics_override()
  return table.copy(self._physics)
end
function test_api.PlayerRef:hud_add(hud_definition)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_remove(id)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_change(id, stat, value)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_get(id)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_set_flags(flags)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_get_flags()
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_set_hotbar_itemcount(count)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_get_hotbar_itemcount()
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_set_hotbar_image(texturename)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_get_hotbar_image()
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_set_hotbar_selected_image(texturename)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:hud_get_hotbar_selected_image()
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:set_minimap_modes(modes, selected_mode)
  error("[test_api]: Method is not implemented.")
end
function test_api.PlayerRef:set_sky(sky_parameters, sky_type)
  if (sky_type~=nil) then
    error("[test_api] Calling of method set_sky without sky_parameters table is depreaced and not supported!")
  end
  if (not test_api.check_table_of_parameters(sky_parameters, ALLOWED_SKY_PARAMS, false, false)) then
    error("[test_api] Calling of method set_sky with invalid sky_parameters table.")
  end
  self._sky_parameters = test_api.apply_table_of_parameters(sky_parameters, DEFAULT_SKY_PARAMS)
end
function test_api.PlayerRef:get_sky()
  return table.copy(self._sky_parameters)
end
function test_api.PlayerRef:get_sky_color()
  error("[test_api] Method get_sky_color is depreaced and is not supported!")
end
function test_api.PlayerRef:set_sun(sun_parameters)
  if (not test_api.check_table_of_parameters(sun_parameters, ALLOWED_SUN_PARAMS, false, false)) then
    error("[test_api] Calling of method set_sun with invalid sun_parameters table.")
  end
  self._sun_parameters = test_api.apply_table_of_parameters(sun_parameters, DEFAULT_SUN_PARAMS)
end
function test_api.PlayerRef:get_sun()
  return table.copy(self._sun_parameters)
end
function test_api.PlayerRef:set_moon(moon_parameters)
  if (not test_api.check_table_of_parameters(moon_parameters, ALLOWED_MOON_PARAMS, false, false)) then
    error("[test_api] Calling of method set_moon with invalid moon_parameters table.")
  end
  self._moon_parameters = test_api.apply_table_of_parameters(moon_parameters, DEFAULT_MOON_PARAMS)
end
function test_api.PlayerRef:get_moon()
  return table.copy(self._moon_parameters)
end
function test_api.PlayerRef:set_stars(stars_parameters)
  if (not test_api.check_table_of_parameters(stars_parameters, ALLOWED_STARS_PARAMS, false, false)) then
    error("[test_api] Calling of method set_stars with invalid stars_parameters table.")
  end
  self._stars_parameters = test_api.apply_table_of_parameters(stars_parameters, DEFAULT_STARS_PARAMS)
end
function test_api.PlayerRef:get_stars()
  return table.copy(self._stars_parameters)
end
function test_api.PlayerRef:set_cloud(cloud_parameters)
  if (not test_api.check_table_of_parameters(cloud_parameters, ALLOWED_CLOUD_PARAMS, false, false)) then
    error("[test_api] Calling of method set_cloud with invalid cloud_parameters table.")
  end
  self._cloud_parameters = test_api.apply_table_of_parameters(cloud_parameters, DEFAULT_CLOUD_PARAMS)
end
function test_api.PlayerRef:get_cloud()
  return table.copy(self._cloud_parameters)
end
function test_api.PlayerRef:override_day_night_ratio(day_night_ratio)
  if ((day_night_ratio==nil) or ((day_night_ration>=0.0) and (day_night_ratio<=1.0))) then 
    self._day_night_ratio = day_night_ratio
  else
    error("[test_api] Calling of method override_day_night_ratio with invalid day_night_ratio table.")
  end
end
function test_api.PlayerRef:get_day_night_ratio()
  return self._day_night_ratio
end
function test_api.PlayerRef:set_local_animation(idle, walk, dig, walk_while_dig, frame_speed)
  self._anim_idle = table.copy(idle)
  self._anim_walk = table.copy(walk)
  self._anim_dig = table.copy(dig)
  self._anim_walk_while_dig = table.copy(walk_while_dig)
end
function test_api.PlayerRef:get_local_animation()
  return self._anim_idle, self._anim_walk, self._anim_dig, self._anim_walk_while_dig, self._anim_frame_speed
end
function test_api.PlayerRef:set_eye_offset(firstperson, thirdperson)
  firstperson = firstperson or vector.new(0, 0, 0)
  thirdperson = thirdperson or vector.new(-10/10, -10/15, -5/5)
  self._eye_offset_firstperson = table.copy(firstperson)
  self._eye_offset_thirdperson = table.copy(thirdperson)
end
function test_api.PlayerRef:get_eye_offset()
  return self._eye_offset_firstperson, self._eye_offset_thirdperson
end
function test_api.PlayerRef:send_mapblock(blockpos)
end
function test_api.PlayerRef:set_lighting(light_definition)
  if (not test_api.check_table_of_parameters(light_definition, ALLOWED_LIGHTING_PARAMS, false, false)) then
    error("[test_api] Calling of method set_lighting with invalid light_definition table.")
  end
  self._lighting = test_api.apply_table_of_parameters(light_definition, DEFAULT_LIGHTING_PARAMS)
end
function test_api.PlayerRef:get_lighting()
  return table.copy(self._lighting)
end
function test_api.PlayerRef:respawn()
end

-- override methods
function test_api.PlayerRef:is_player()
  return true
end
function test_api.PlayerRef:get_inventory()
  return self:get_meta():get_inventory()
end
test_api.PlayerRef._wield_list = "main"
function test_api.PlayerRef:get_wield_list()
  return self._wield_list
end
test_api.PlayerRef._wield_index = 1
function test_api.PlayerRef:get_wield_index()
  return self._wield_index
end
function test_api.PlayerRef:get_wielded_item()
  local inv = self:get_inventory()
  return inv:get_stack(self._wield_list, self._wield_index)
end
function test_api.PlayerRef:set_wielded_item(item)
  local inv = self:get_inventory()
  inv:set_stack(self._wield_list, self._wield_index, item)
end

-- special methods added by test_api 
function test_api.PlayerRef:set_player_control(player_control)
  if (not test_api.check_table_of_parameters(player_control, ALLOWED_PLAYER_CONTROL_PARAMS, false, false)) then
    error("[test_api] Calling of method set_lighting with invalid light_definition table.")
  end
  self._player_control = test_api.apply_table_of_parameters(player_control, DEFAULT_PLAYER_CONTROL_PARAMS)
end
function test_api.PlayerRef:set_wield_index(index)
  self._wield_index = index
end


