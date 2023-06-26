
function table.copy(t, seen)
	local n = {}
	seen = seen or {}
	seen[t] = n
	for k, v in pairs(t) do
		n[(type(k) == "table" and (seen[k] or table.copy(k, seen))) or k] =
			(type(v) == "table" and (seen[v] or table.copy(v, seen))) or v
	end
	return n
end


function table.insert_all(t, other)
	for i=1, #other do
		t[#t + 1] = other[i]
	end
	return t
end


function table.key_value_swap(t)
	local ti = {}
	for k,v in pairs(t) do
		ti[v] = k
	end
	return ti
end


function table.shuffle(t, from, to, random)
	from = from or 1
	to = to or #t
	random = random or math.random
	local n = to - from + 1
	while n > 1 do
		local r = from + n-1
		local l = from + random(0, n-1)
		t[l], t[r] = t[r], t[l]
		n = n-1
	end
end

