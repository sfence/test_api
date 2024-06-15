
minetest = {}
core = minetest

if MINETEST_WORLD_SUBPATH then
  local dir = string.sub(debug.getinfo(1).source,2,-13)
  
  MINETEST_WORLD_PATH = dir.."../"..MINETEST_WORLD_SUBPATH
  
  print("[test_api] World directory set to: "..MINETEST_WORLD_PATH)
end

-- special test api added methods

test_api.loaded_mods = {}
local loaded_mods = test_api.loaded_mods
test_api.current_modname = nil

function test_api.load_module(path_to_dir, module_name)
  loaded_mods[module_name] = path_to_dir
  print("[test_api] Loading module "..module_name.." from path "..path_to_dir)
  test_api.current_modname = module_name
  dofile(path_to_dir.."/init.lua")
  test_api.current_modname = nil
end

function test_api.check_table_of_parameters(parameters, allowed_table, allow_extra_params, allow_extra_subparams)
  for key, value in parameters do
    local allowed_value = allowed_table[key]
    if allowed_value then
      if (type(allowed_value)=="string") then
        if (type(value)~=allowed_value) then
          return false
        end
      elseif (type(allowed_value)=="function") then
        if (not allowed_value(value)) then
          return false
        end
      elseif (type(allowed_value)=="boolean") then
        -- true -> this value is required to be something, not nil
        -- false -> it is forbidden to set this value
        if (not allowed_value) then
          return false
        end
      elseif (type(allowed_value)=="table") then
        if (not test_api.check_table_of_parameters(value, allowed_value, allow_extra_subparams, allow_extra_subparams)) then
        end
      else
        -- unknown check type
        return false
      end
    elseif (not allow_extra_params) then
      return false
    end
  end
  return true
end

function test_api.check_ColorRGB(value)
  if ((type(value)=="number") and (value>=0) and (value<=255) and (math.floor(value)==value)) then
    return true
  end
  return false
end
function test_api.check_ColorA(value)
  if (value==nil) then
    return true
  end
  return test_api.check_ColorRGB(value)
end

local ALLOWED_COLORSPEC_PARAMS = {
  a = test_api.check_ColorA,
  r = test_api.check_ColorRGB,
  g = test_api.check_ColorRGB,
  b = test_api.check_ColorRGB,
}

function test_api.check_ColorSpec(value)
  if (type(value)=="table") then
    return test_api.check_table_of_parameters(value, ALLOWED_COLORSPEC_PARAMS, false, false)
  elseif (type(value)=="number") then
    if ((value>=0x00000000) and (value<=0xFFFFFFFF) and (math.floor(value)==value)) then
      return true
    end
  elseif (type(value)=="string") then
    -- TODO
  end
  return false
end

function test_api.get_check_float_range(min, max)
  return function(value)
      if ((type(value)=="number") and ((min==nil) or (value>=min)) and ((max==nil) or (value<=max))) then
        return true
      end
      return false
    end
end
function test_api.get_check_integer_range(min, max)
  return function(value)
      if ((type(value)=="number") and ((min==nil) or (value>=min)) and ((max==nil) or (value<=max)) and (math.floor(value)==value)) then
        return true
      end
      return false
    end
end
function test_api.get_check_string_variants(variants)
  return function(value)
      for _,variant in pairs(variants) do
        if (value==variant) then
          return true
        end
      end
      return false
    end
end

function test_api.apply_table_of_parameters(parameters, default_parameters)
  local outs = table.copy(parameters)
  for key,value in pairs(default_parameters) do
    if (outs[key]==nil) then
      if (type(value)=="table") then
        outs[key] = table.copy(value)
      else
        outs[key] = value
      end
    end
  end
  return outs
end

local COLOR_NAMES = {
  aliceblue = "#F0F8FF",
  antiquewhite = "#FAEBD7",
  aqua = "#00FFFF",
  aquamarine = "#7FFFD4",
  azure = "#F0FFFF",
  beige = "#F5F5DC",
  bisque = "#FFE4C4",
  black = "#000000",
  blanchedalmond = "#FFEBCD",
  blue = "#0000FF",
  blueviolet = "#8A2BE2",
  brown = "#A52A2A",
  burlywood = "#DEB887",
  cadetblue = "#5F9EA0",
  chartreuse = "#7FFF00",
  chocolate = "#D2691E",
  coral = "#FF7F50",
  cornflowerblue = "#6495ED",
  cornsilk = "#FFF8DC",
  crimson = "#DC143C",
  cyan = "#00FFFF",
  darkblue = "#00008B",
  darkcyan = "#008B8B",
  darkgoldenrod = "#B8860B",
  darkgray = "#A9A9A9",
  darkgreen = "#006400",
  darkgrey = "#A9A9A9",
  darkkhaki = "#BDB76B",
  darkmagenta = "#8B008B",
  darkolivegreen = "#556B2F",
  darkorange = "#FF8C00",
  darkorchid = "#9932CC",
  darkred = "#8B0000",
  darksalmon = "#E9967A",
  darkseagreen = "#8FBC8F",
  darkslateblue = "#483D8B",
  darkslategray = "#2F4F4F",
  darkslategrey = "#2F4F4F",
  darkturquoise = "#00CED1",
  darkviolet = "#9400D3",
  deeppink = "#FF1493",
  deepskyblue = "#00BFFF",
  dimgray = "#696969",
  dimgrey = "#696969",
  dodgerblue = "#1E90FF",
  firebrick = "#B22222",
  floralwhite = "#FFFAF0",
  forestgreen = "#228B22",
  fuchsia = "#FF00FF",
  gainsboro = "#DCDCDC",
  ghostwhite = "#F8F8FF",
  gold = "#FFD700",
  goldenrod = "#DAA520",
  gray = "#808080",
  green = "#008000",
  greenyellow = "#ADFF2F",
  grey = "#808080",
  honeydew = "#F0FFF0",
  hotpink = "#FF69B4",
  indianred = "#CD5C5C",
  indigo = "#4B0082",
  ivory = "#FFFFF0",
  khaki = "#F0E68C",
  lavender = "#E6E6FA",
  lavenderblush = "#FFF0F5",
  lawngreen = "#7CFC00",
  lemonchiffon = "#FFFACD",
  lightblue = "#ADD8E6",
  lightcoral = "#F08080",
  lightcyan = "#E0FFFF",
  lightgoldenrodyellow = "#FAFAD2",
  lightgray = "#D3D3D3",
  lightgreen = "#90EE90",
  lightgrey = "#D3D3D3",
  lightpink = "#FFB6C1",
  lightsalmon = "#FFA07A",
  lightseagreen = "#20B2AA",
  lightskyblue = "#87CEFA",
  lightslategray = "#778899",
  lightslategrey = "#778899",
  lightsteelblue = "#B0C4DE",
  lightyellow = "#FFFFE0",
  lime = "#00FF00",
  limegreen = "#32CD32",
  linen = "#FAF0E6",
  magenta = "#FF00FF",
  maroon = "#800000",
  mediumaquamarine = "#66CDAA",
  mediumblue = "#0000CD",
  mediumorchid = "#BA55D3",
  mediumpurple = "#9370DB",
  mediumseagreen = "#3CB371",
  mediumslateblue = "#7B68EE",
  mediumspringgreen = "#00FA9A",
  mediumturquoise = "#48D1CC",
  mediumvioletred = "#C71585",
  midnightblue = "#191970",
  mintcream = "#F5FFFA",
  mistyrose = "#FFE4E1",
  moccasin = "#FFE4B5",
  navajowhite = "#FFDEAD",
  navy = "#000080",
  oldlace = "#FDF5E6",
  olive = "#808000",
  olivedrab = "#6B8E23",
  orange = "#FFA500",
  orangered = "#FF4500",
  orchid = "#DA70D6",
  palegoldenrod = "#EEE8AA",
  palegreen = "#98FB98",
  paleturquoise = "#AFEEEE",
  palevioletred = "#DB7093",
  papayawhip = "#FFEFD5",
  peachpuff = "#FFDAB9",
  peru = "#CD853F",
  pink = "#FFC0CB",
  plum = "#DDA0DD",
  powderblue = "#B0E0E6",
  purple = "#800080",
  rebeccapurple = "#663399",
  red = "#FF0000",
  rosybrown = "#BC8F8F",
  royalblue = "#4169E1",
  saddlebrown = "#8B4513",
  salmon = "#FA8072",
  sandybrown = "#F4A460",
  seagreen = "#2E8B57",
  seashell = "#FFF5EE",
  sienna = "#A0522D",
  silver = "#C0C0C0",
  skyblue = "#87CEEB",
  slateblue = "#6A5ACD",
  slategray = "#708090",
  slategrey = "#708090",
  snow = "#FFFAFA",
  springgreen = "#00FF7F",
  steelblue = "#4682B4",
  tan = "#D2B48C",
  teal = "#008080",
  thistle = "#D8BFD8",
  tomato = "#FF6347",
  turquoise = "#40E0D0",
  violet = "#EE82EE",
  wheat = "#F5DEB3",
  white = "#FFFFFF",
  whitesmoke = "#F5F5F5",
  yellow = "#FFFF00",
  yellowgreen = "#9ACD32",
}

local function hex_string_to_color_part(hex)
  if (hex:len()==2) then
    return tonumber("0x"..hex)
  else
    return tonumber("0x"..hex..hex)
  end
end

function test_api.decode_ColorString(color_string)
  local loc = color_string:find("#")
  local color_hex
  if ((loc==nil) or (loc>1)) then
    local color_name = color_string
    if loc then
      color_name = color_string:sub(1,loc)
    end
    local color_hex = COLOR_NAMES[color_name]
    if (not color_hex) then
      error("[test_api] Bad ColorString '"..color_string.."', name have not been recognized.")
    end
    color_hex = color_hex..color_string:sub(loc+1, -1)
  else
    color_hex = color_string
  end
  -- hex color string
  loc = color_hex:len()
  local rgba = {a=255}
  if ((loc==4) or (loc==5)) then
    rgba.r = hex_string_to_color_part(color_hex:sub(2,2))
    rgba.g = hex_string_to_color_part(color_hex:sub(3,3))
    rgba.b = hex_string_to_color_part(color_hex:sub(4,4))
    if (loc==5) then
      rgba.a = hex_string_to_color_part(color_hex:sub(5,5))
    end
  elseif ((loc==7) or (loc==8) or (loc==9)) then
    rgba.r = hex_string_to_color_part(color_hex:sub(2,3))
    rgba.g = hex_string_to_color_part(color_hex:sub(4,5))
    rgba.b = hex_string_to_color_part(color_hex:sub(6,7))
    if (loc>7) then
      rgba.a = hex_string_to_color_part(color_hex:sub(8,9))
    end
  else
    error("[test_api] Bad ColorString '"..color_string.."', unexpected color_hex '"..color_hex.."'.")
  end
  return rgba
end

