require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: 'Eduardo', email: 'eduardo@gmail.com',
                      password: 'password', password_confirmation: 'password')
  end

  test 'should be valid' do
    assert @chef.valid?
  end

  test 'name should be present' do
    @chef.chefname = ''
    assert_not @chef.valid?
  end

  test 'chefname should be less than 30 characters' do
    @chef.chefname = 'a' * 31
    assert_not @chef.valid?
  end

  test 'email should be present' do
    @chef.email = ''
    assert_not @chef.valid?
  end

  test 'email should not be more than 255 characters long' do
    @chef.email = 'a' * 257
    assert_not @chef.valid?
  end

  test 'email should be correct format' do
    valid_emails = %w[user@example.com eduardo@gmail.com garibo.eduardo90@gmail.com
                      eduardo_garibo@outlook.com]
    valid_emails.each do |valid|
      @chef.email = valid
      assert @chef.valid?, "#{valid.inspect} should be valid"
    end
  end

  test 'should reject invalid addresses' do
    invalid_emails = %w[eduardo.com user@example eduardo@garibo,com]
    invalid_emails.each do |invalid|
      @chef.email = invalid
      assert_not @chef.valid?, "#{invalid.inspect} should be invalid"
    end
  end

  test 'email should be unique and case insensitive' do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test 'email should be lower case before hits db' do
    mixed_email = 'John@EXAMPLE.com'
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test 'password should be present' do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test 'password should be at least 5 character' do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end

  test 'associated recipes should be removed' do
    @chef.save
    @chef.recipes.create!(name: 'testing destroy', description: 'testing destroy')
    assert_difference 'Recipe.count', -1 do
      @chef.destroy
    end
  end
end