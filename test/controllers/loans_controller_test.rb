require 'test_helper'

class LoansControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get expired' do
    3.times do
      Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end

    Fabricate(:loan, user_id: @user.id, expired_payments_count: 0)
    Fabricate(:loan, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)

    get :expired, start: Date.today

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get close to expire' do
    3.times { Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.tomorrow) }

    Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.yesterday)
    Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, next_payment_expire_at: Date.tomorrow)
    Fabricate(:loan, next_payment_expire_at: Date.tomorrow)

    get :close_to_expire, start: Date.today

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get expired in js' do
    3.times do
      Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end

    Fabricate(:loan, user_id: @user.id, expired_payments_count: 0)
    Fabricate(:loan, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)

    xhr :get, :expired, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get close to expire in js' do
    3.times { Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.tomorrow) }
    Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.yesterday)
    Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, next_payment_expire_at: Date.tomorrow)
    Fabricate(:loan, next_payment_expire_at: Date.tomorrow)

    xhr :get, :close_to_expire, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get show' do
    loan = Fabricate(:loan, user_id: @user.id)

    get :show, id: loan.to_param, format: :js

    assert_response :success
    assert_not_nil assigns(:loan)
    assert_template 'loans/show'
  end
end
