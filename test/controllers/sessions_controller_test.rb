require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should prompt for login" do
    get login_url
    assert_response :success
  end

  test "should log in" do
    post login_url, params: { name: @user.name, password: 'secret' }
    assert_redirected_to admin_url
    assert_equal @user.id, session[:user_id]
  end

  test "should fail login" do
    post login_url, params: { name: @user.name, password: 'wrong' }
    assert_redirected_to login_url
  end

  test "should log out" do
    delete logout_url
    assert_redirected_to store_index_url
  end

end
