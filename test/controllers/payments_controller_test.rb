require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get expired' do
    3.times { Fabricate(:payment_for_user, user_id: @user.id, expiration_date: 2.days.ago.to_date) }
    Fabricate(:payment_for_user, user_id: @user.id, expiration_date: Date.today)

    get :expired

    assert_response :success
    assert_equal 3, assigns(:payments).size
    assert_template 'payments/index'
  end

  test 'should get close_to_expire' do
    3.times { Fabricate(:payment_for_user, user_id: @user.id, expiration_date: Date.tomorrow) }
    Fabricate(:payment_for_user, user_id: @user.id, expiration_date: Date.today)

    get :close_to_expire

    assert_response :success
    assert_equal 3, assigns(:payments).size
    assert_template 'payments/index'
  end

  test 'should get expired in js' do
    3.times { Fabricate(:payment_for_user, user_id: @user.id, expiration_date: 2.days.ago.to_date) }
    Fabricate(:payment_for_user, user_id: @user.id, expiration_date: Date.today)

    xhr :get, :expired, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:payments).size
    assert_template 'payments/index'
  end

  test 'should get close to expire in js' do
    3.times { Fabricate(:payment_for_user, user_id: @user.id, expiration_date: Date.tomorrow) }
    Fabricate(:payment_for_user, user_id: @user.id, expiration_date: Date.today)

    xhr :get, :close_to_expire, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:payments).size
    assert_template 'payments/index'
  end

  test 'should get show' do
    payment = Fabricate(:payment_for_user, user_id: @user.id)

    get :show, id: payment.to_param, format: :js

    assert_response :success
    assert_not_nil assigns(:payment)
    assert_template 'payments/show'
  end
end
