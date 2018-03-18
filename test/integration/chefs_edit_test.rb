require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create(chefname: 'Jose Eduardo', email: 'jose@example.com',
                        password: 'password', password_confirmation: 'password')
  end

  test 'reject an invalid edit' do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: ' ', email: 'edd@gmail.com ' } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'accept valid edit' do
    sign_is_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: 'eduardo1 ', email: 'eddie@gmail.com ' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'eduardo1', @chef.chefname
    assert_match 'eddie@gmail.com', @chef.email
  end
end