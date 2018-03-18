require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create(chefname: 'Jose Eduardo', email: 'jose@example.com',
                        password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'Tacos al vapor',
                            description: 'Buenos tacos de cabeza', chef: @chef)
    @recipe2 = @chef.recipes.build(name: 'Tacos al pastor', description: 'Bueos tacos de pastor')
    @recipe2.save
  end
  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end
  test 'should get recipes listing' do
    get recipes_url
    assert_template 'recipes/index'
    assert_select 'a[href=?]', recipe_path(@recipe), text: @recipe.name
  end
  test'should get recipes show' do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
  test 'create new valid recipe' do
    sign_is_as(@chef, 'password')
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = 'chicken saute'
    description_of_recipe = 'Good chicken saute'
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end
  test 'reject invalid recipe submition' do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: '', description: '' } }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end
