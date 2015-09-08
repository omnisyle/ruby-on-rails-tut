require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test 'user edit unsuccessful' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: '', email: 'foo@invalia.com', password: 'foo', password_confirmation: 'bar' }
    assert_template 'users/edit'
  end

  test 'user edit successful with friendly forwarding' do

    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'True Name'
    email = 'valid@email.com'
    patch user_path(@user), user: { name: name,
                                   email: email,
                                   password: 'password',
                                   password_confirmation: 'password' }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end


end
