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

  test "should get expired" do
    expired_fee = Fabricate(:fee, expiration_date: 2.year.ago)

    post :expired, date_range: { start: 3.year.ago, end: Date.today }, format: 'js'

    assert_response :success
    assert_template "dashboard/debts"
  end

  test "should get close to expire" do
    close_to_expire_fee = Fabricate(:fee, expiration_date: Date.today-1)

    post :expired, date_range: { start: Date.today-7, end: Date.today }, format: 'js'

    assert_response :success
    assert_template "dashboard/debts"
  end

  test "should get more info on fee" do
    expired_fee = Fabricate(:fee, expiration_date: 2.year.ago)

    post :expiring_info, id: expired_fee.to_param, format: 'js'

    assert_response :success
    assert_template "dashboard/expiring_info"
  end
end
