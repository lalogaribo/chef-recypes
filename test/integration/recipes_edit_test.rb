require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create(chefname: 'Jose Eduardo', email: 'jose@example.com',
                        password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'Tacos al vapor',
                            description: 'Buenos tacos de cabeza', chef: @chef)
  end

  test 'reject invalid recipe update' do
      get edit_recipe_path(@recipe)
      assert_template 'recipes/edit'
      patch recipe_path(@recipe), params: { recipe: { name: '', description: 'some desc'}}
      assert_template 'recipes/edit'
      assert_select 'h2.panel-title'
      assert_select 'div.panel-body'
  end

  test 'successfully edit a recipe' do
      get edit_recipe_path(@recipe)
      assert_template 'recipes/edit'
      name = 'taquitos de asada'
      description = 'carne de res'
      patch recipe_path(@recipe), params: { recipe: { name: name, description: description }}
      assert_redirected_to @recipe
      assert_not flash.empty?
      @recipe.reload
      assert_match name, @recipe.name
      assert_match description, @recipe.description
  end
end
