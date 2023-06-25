
function test_api.graph_empty_data(graph_structure)
  local empty = {}
  for graph_name,graph_keys in pairs(graph_structure) do
    empty[graph_name] = {}
    for _,key in pairs(graph_keys) do
      empty[graph_name][key] = {}
    end
  end
  return empty
end

