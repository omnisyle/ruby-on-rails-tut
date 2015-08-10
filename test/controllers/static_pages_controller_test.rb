require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  def setup
    @base_title = 'Ruby on Rails tutorial app'
  end

  test "should get home" do
    get :home
    assert_select('title', "#{@base_title}")
    assert_response :success

  end

  test "should get help" do
    get :help
    assert_select('title', "Help | #{@base_title}")
    assert_response :success

  end

  test "should get about" do
    get :about
    assert_select('title', "About | #{@base_title}")
    assert_response :success

  end

  test 'should get contact page' do
    get :contact
    assert_select('title', "Contact | #{@base_title}")
    assert_response :success
  end

end
