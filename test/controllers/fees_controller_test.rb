require 'test_helper'

class FeesControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get expired' do
    3.times { Fabricate(:fee_for_user, user_id: @user.id, expiration_date: 2.days.ago.to_date) }
    Fabricate(:fee_for_user, user_id: @user.id, expiration_date: Date.today)

    get :expired

    assert_response :success
    assert_equal 3, assigns(:fees).size
    assert_template 'fees/index'
  end

  test 'should get close_to_expire' do
    3.times { Fabricate(:fee_for_user, user_id: @user.id, expiration_date: Date.tomorrow) }
    Fabricate(:fee_for_user, user_id: @user.id, expiration_date: Date.today)

    get :close_to_expire

    assert_response :success
    assert_equal 3, assigns(:fees).size
    assert_template 'fees/index'
  end

  test 'should get expired in js' do
    3.times { Fabricate(:fee_for_user, user_id: @user.id, expiration_date: 2.days.ago.to_date) }
    Fabricate(:fee_for_user, user_id: @user.id, expiration_date: Date.today)

    xhr :get, :expired, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:fees).size
    assert_template 'fees/index'
  end

  test 'should get close to expire in js' do
    3.times { Fabricate(:fee_for_user, user_id: @user.id, expiration_date: Date.tomorrow) }
    Fabricate(:fee_for_user, user_id: @user.id, expiration_date: Date.today)

    xhr :get, :close_to_expire, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:fees).size
    assert_template 'fees/index'
  end

  test 'should get show' do
    fee = Fabricate(:fee_for_user, user_id: @user.id)

    get :show, id: fee.to_param, format: :js

    assert_response :success
    assert_not_nil assigns(:fee)
    assert_template 'fees/show'
  end
end
