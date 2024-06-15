
test_api.known_players = {}

function test_api.add_player(player_name, pos, def)
  def = def or {}
  def._pos = pos or vector.new(0,0,0)
  test_api.known_players[player_namei] = def
end

function test_api.join_player(player_name, ip)
  for _,func in pairs(minetest.registered_on_prejoin_players) do
    local text = func(player_name, ip)
    if text then
      minetest.log("info", "[test_api] Player \""..player_name.."\" join failed with message: "..text)
      return false
    end
  end
  local player_ref
  if not test_api.known_players[player_name] then
    for _,func in pairs(minetest.registered_on_newplayers) do
      func(player_ref)
    end
  else
    
  end
end

function test_api.disconnect_player(player_name)
  local player_ref = minetest.get_player_by_name(player_name)
  test_api.known_players[player_name] = player_ref.store_data()
end

