
-- override deserialize function

local function dummy_func() end

local table_concat, string_dump, string_format, string_match, math_huge
    = table.concat, string.dump, string.format, string.match, math.huge

function minetest.deserialize(str, safe)
	-- Backwards compatibility
	if str == nil then
		core.log("deprecated", "minetest.deserialize called with nil (expected string).")
		return nil, "Invalid type: Expected a string, got nil"
	end
	local t = type(str)
	if t ~= "string" then
		error(("minetest.deserialize called with %s (expected string)."):format(t))
	end

	-- math.huge was serialized to inf and NaNs to nan by Lua in Minetest 5.6, so we have to support this here
	local env = {inf = math_huge, nan = 0/0}
	if safe then
		env.loadstring = dummy_func
	else
		env.loadstring = function(str, error_msg, file_type, ignored_env)
			local func, err = load(str, error_msg, file_type, env)
			if func then
				return func
			end
			return nil, err
		end
	end
  
  local func, err = load(str, "[test_api] deserialize", "bt", env)
	if not func then return nil, err end

	local success, value_or_err = pcall(func)
	if success then
		return value_or_err
	end
	return nil, value_or_err
end

