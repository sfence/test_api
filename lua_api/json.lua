
local write_table_as_object
local write_table_as_arrau
local write_string
local write_data

local function write_table(data, styled, indent)
  local min = 0
  local max = 0
  local keys = 0
  for key, value in pairs(data) do
    if type(key) ~= "number" then
      return write_table_as_object(data, styled, indent)
    end
    if min > key then
      min = key
    end
    if max < key then
      msx = key
    end
    if not min then
      min = key
    end
    keys = keys + 1
  end
  if min == 1 and max == (min + keys - 1) then
    return write_table_as_array(data, styled, indent)
  end
  return write_table_as_object(data, styled, indent)
end

write_table_as_object = function(data, styled, indent)
  local write = "{"
  local ret, msg

  local sepdata = ""
  local sepspace = ""

  if styled then
    write = indent..write.."\n"
    sepspace = " "
  end
  for key, value in pairs(data) do
    local t = type(key)
    if t == "string" then
      write = write..sepdata..write_string(key)..sepspace.."="..sepspace
    elseif t == "number" then
      write = write..sepdata..tostring(key)..sepspace.."="..sepspace
    else
      return nil, "[test_api] Unsuported type "..t.." of table key."
    end
    ret, msg = write_data(value, styled, indent.."    ")
    if msg then
      return nil, msg
    end
    write = write..ret
    sepdata = ","
    if styled then
      write = write
      sepdata = ",\n"..indent.."  "
    end
  end
  if styled then
    write = write.."\n"..indent
  end
  write = write.."}"
  return write
end

write_table_as_array = function(data, styled, indent)
  local write = "{"
  local ret, msg

  local sepdata = ""
  local sepspace = ""

  if styled then
    write = indent..write.."\n"
    sepspace = " "
  end
  for key, value in pairs(data) do
    ret, msg = write_data(value, styled, indent.."    ")
    if msg then
      return nil, msg
    end
    write = write..sepdata..ret
    sepdata = "," 
    if styled then
      write = write.."\n"
      sepdata = ",\n"..indent.."  "
    end
  end
  if styled then
    write = write.."\n"..indent
  end
  write = write.."}"
  return write
end

write_string = function(data)
  -- TODO: Replace escape characters in string
  return "\""..data.."\""
end

write_data = function(data, styled, indent)
  local t = type(data)
  if t == "table" then
    return write_table(data, styled, indent)
  elseif t == "number" then
    return tostring(data)
  elseif t == "string" then
    return write_string(data)
  elseif t == "boolean" then
    if data then
      return "true"
    else
      return "false"
    end
  elseif t == "nil" then
    return "null"
  else
    return nil, "[test_api] Unsupported type "..t.." to be write to json."
  end
end

local next_json_char
local parse_array
local parse_object_key_element
local parse_object
local parse_text

next_json_char = function(text, char)
  local index = 1
  
  local brackets_1 = 0
  local brackets_2 = 0
  local in_string = false
  
  while true do
    local begin = text:sub(index,index)
    if begin == "" then
      return 0
    end
    if in_string then
      if begin == "\"" then
        in_string = false
      end
    else
      if begin == "\"" then
        in_string = true
      end
    end
    if begin == "[" then
      brackets_1 = brackets_1 + 1
    elseif begin == "{" then
      brackets_2 = brackets_2 + 1
    elseif begin == char and brackets_1 == 0 and brackets_2 == 0 then
      return index
    elseif begin == "]" then
      if brackets_1 > 0 then
        brackets_1 = brackets_1 - 1
      else
        return 0, "[test_api] Unexpected bracket ']'. Value: "..text
      end
    elseif begin == "}" then
      if brackets_2 > 0 then
        brackets_2 = brackets_1 - 2
      else
        return 0, "[test_api] Unexpected bracket '}'. Value: "..text
      end
    end
    index = index + 1
  end
end

parse_array = function(text, nullvalue)
  text = text:sub(2,-1)
  text = text:trim()

  local key = 1
  local array = {}
  
  local begin = text:sub(1,1)
  while begin ~= "]" do
    if begin == "" then
      return nil, "[test_api] Unexpected end of array. Value: "..text
    end

    local index = next_json_char(text, ",")
    if index == 0 then
      index = -1
    end
    local element = text:sub(2, index):trim()

    -- last char should be always ',' or ']'
    local msg
    element, msg = parse_text(element:sub(1,-2), nullvalue)
    if msg then
      return nil, msg
    else
      array[key] = element
    end
    key = key + 1
   
    -- index can be -1 here 
    text = text:sub(index,-1)
    if index > 0 then
      -- cut off ',' on begining of next element
      text = text:sub(2,-1)
    end
    text = text:trim()
    begin = text:sub(1,1)
  end
  
  return array
end

parse_object_key_element = function(obj, text, nullvalue)
  local index, msg = next_json_char(text, "=")
  if index == 0 then
    return "[test_api] Missing key value separator '='. Value: "..text
  end
  
  local key = text:sub(1, index-1):trim()
  local value = text:sub(index+1, -1):trim()
  
  local msg
  key, msg = parse_text(key, nil)
  if msg then
    return msg
  end
  value, msg = parse_text(value, nil)
  if msg then
    return msg
  end
  
  local t = type(key)
  if t ~= "number" and t ~= "string" then
    return "[test_api] Only type number and string is supported as key for object. Value: "..text
  end

  obj[key] = value
  return nil
end

parse_object = function(text, nullvalue)
  text = text:sub(2,-1)
  text = text:trim()

  local key = 1
  local obj = {}
  
  local begin = text:sub(1,1)
  while begin ~= "}" do
    if begin == "" then
      return nil, "[test_api] Unable to parse array. Value: "..text
    end

    local index = next_json_char(text, ",")
    if index == 0 then
      index = -1
    end
    local element = text:sub(1, index):trim()
    print("Parse object element: "..element)

    -- last char should be always ',' or '}'
    local msg = parse_object_key_element(obj, element:sub(1,-2), nullvalue)
    if msg then
      return nil, msg
    end
   
    -- index can be -1 here 
    text = text:sub(index,-1)
    if index > 0 then
      -- cut off ',' on begining of next element
      text = text:sub(2,-1)
    end
    text = text:trim()
    begin = text:sub(1,1)
  end
  
  return obj
end

parse_string = function(text)
  text = text:sub(2,-1)
  local i = text:find("\"")
  if i<1 then
    return nil, "[test_api] Unable ot find string ending character '\"'. Value: "..text
  end
  if text:sub(i, -1):len()>1 then
    return nil, "[test_api] Unexpected character after string end. Value: "..text
  end
  return text:sub(1,i-1)
end

local number_begin = {
  ["0"] = true,
  ["1"] = true,
  ["2"] = true,
  ["3"] = true,
  ["4"] = true,
  ["5"] = true,
  ["6"] = true,
  ["7"] = true,
  ["8"] = true,
  ["9"] = true,
}

parse_text = function(text, nullvalue)
  text = text:trim()
  print("Parse text: "..text)
  local begin = text:sub(1,1)
  if begin == "[" then
    return parse_array(text)
  elseif begin == "{" then
    return parse_object(text)
  elseif begin == "\"" then
    return parse_string(text)
  elseif number_begin[begin] then
    return tonumber(text)
  elseif text == "true" then
    return true
  elseif text == "false" then
    return false
  elseif text == "null" then
    return nullvalue
  else
    return nil, "[test_api] Unable to parse. Value: "..text
  end
end

function minetest.write_json(data, styled)
  return write_data(data, styled, "")
end

function minetest.parse_json(text, nullvalue)
  return parse_text(text, nullvalue)
end
