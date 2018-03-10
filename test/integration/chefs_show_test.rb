require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
 def setup
   @chef = Chef.create(chefname: 'Jose Eduardo', email: 'jose@example.com',
                       password: 'password', password_confirmation: 'password')
   @recipe = Recipe.create(name: 'Tacos al vapor',
                           description: 'Buenos tacos de cabeza', chef: @chef)
   @recipe2 = @chef.recipes.build(name: 'Tacos al pastor', description: 'Bueos tacos de pastor')
   @recipe2.save
 end

  test 'should get chefs show' do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: @recipe.name
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
end
