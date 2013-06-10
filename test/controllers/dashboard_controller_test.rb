require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end 

  test "should get index" do
    get :index

    assert_response :success
  end
end
