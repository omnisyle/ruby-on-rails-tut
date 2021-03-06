require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: 'Test User', email: 'user@example.com',
                      password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email should accept valid email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each { |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    }
  end

  test 'email should reject invalid email addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each { |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should not be valid"
    }
  end

  test 'email should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email should be saved lowercase' do
    mixed_case_email = 'test@aAaaXam.com'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end


  test 'password should be present' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    michael = users(:michael)
    archer = users(:archer)

    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)

  end

  test 'feed should have the right post' do
    michael = users(:michael)
    lana = users(:lana)
    archer = users(:archer)
    # posts from lana, michael follows lana, so he should be able
    # to view lana's post
    lana.microposts.each { |post_following|
      assert michael.feed.include?(post_following)
    }

    #michael must be able to see his own posts in
    michael.microposts.each { |post_self|
      assert michael.feed.include?(post_self)
    }

    # cannot see posts from unfollowed users
    archer.microposts.each { |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    }

  end

end
