function dump(var, prefix)
    local text = ""
    if (not prefix) then
      prefix = ""
    end
    if type(var)=="table" then
      text = prefix.."{\n"
      local tabprefix = ""
      for key, value in pairs(var) do
        text = text .. prefix .. "  " .. key .. " = " .. dump(value, tabprefix.."  ").."\n"
        tabprefix = prefix
      end
      text = text .. prefix.."}\n"
    else
      text = prefix .. tostring(var)
    end
    return text
  end
