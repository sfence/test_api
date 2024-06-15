
test_api.registered_crafts = {
  normal = {},
  shapeless = {},
  toolrepair = {},
  cooking = {},
  fuel = {},
}
local registered_crafts = test_api.registered_crafts

function minetest.register_craft(recipe)
  recipe.type = recipe.type or "normal"
  
  if (recipe.type=="normal") then
    assert(type(recipe.output)=="string", "[test_api] register_craft recipe required valid output field. "..dump(recipe))
    assert(type(recipe.recipe)=="table", "[test_api] register_craft recipe required valid recipe field. "..dump(recipe))
    local recipe_width = nil
    local recipe_height = #recipe.recipe
    for _,recipe_table in pairs(recipe.recipe) do
      assert(type(recipe_table)=="table", "[test_api] register_craft recipe required valid recipe table. "..dump(recipe))
      recipe_width = recipe_width or #recipe_table
      assert(recipe_width==#recipe_table, "[test_api] register_craft recipe required valid recipe table. "..dump(recipe))
    end
  elseif (recipe.type=="shapeless") then
    assert(type(recipe.output)=="string", "[test_api] register_craft recipe required valid output field. "..dump(recipe))
    assert(type(recipe.recipe)=="table", "[test_api] register_craft recipe required valid recipe field. "..dump(recipe))
    for _,recipe_item in pairs(recipe.recipe) do
      assert(type(recipe_item)=="string", "[test_api] register_craft recipe required valid recipe table. "..dump(recipe))
    end
  elseif (recipe.type=="toolrepair") then
    assert(type(recipe.additional_wear)=="number", "[test_api] register_craft recipe required valid additional_wear field. "..dump(recipe))
  elseif (recipe.type=="cooking") then
    recipe.cook_time = recipe.cook_time or 1.0
    assert(type(recipe.output)=="string", "[test_api] register_craft recipe required valid output field. "..dump(recipe))
    assert(type(recipe.recipe)=="string", "[test_api] register_craft recipe required valid recipe field. "..dump(recipe))
    assert(type(recipe.cook_time)=="number", "[test_api] register_craft recipe required valid cook_time field. "..dump(recipe))
  elseif (recipe.type=="fuel") then
    recipe.burn_time = recipe.burn_time or 1.0
    assert(type(recipe.recipe)=="string", "[test_api] register_craft recipe required valid recipe field. "..dump(recipe))
    assert(type(recipe.burn_time)=="number", "[test_api] register_craft recipe required valid burn_time field. "..dump(recipe))
  else
    error("[test_api] Unexpected type of register_craft recipe. "..dump(recipe))
  end
  
  if recipe.replacements then
    assert(type(recipe.replacements)=="table", "[test_api] register_craft recipe required valid replacements field. "..dump(recipe))
    for _,replacement in pairs(recipe.replacements) do
      assert(#replacement==2, "[test_api] register_craft recipe required valid replacements table. "..dump(recipe))
      assert(#replacement==2, "[test_api] register_craft recipe required valid replacements table. "..dump(recipe))
    end
  end
  
  table.insert(registered_crafts[recipe.type], recipe)
end

