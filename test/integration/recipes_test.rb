require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create(chefname: 'Jose Eduardo', email: 'jose@example.com')
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
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end

end
