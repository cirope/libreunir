require 'test_helper'

class LoansControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get expired' do
    fabricate_expired

    get :expired, start: Date.today

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get close to expire' do
    fabricate_close_to_expire

    get :close_to_expire, start: Date.today

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get expired in js' do
    fabricate_expired

    xhr :get, :expired, start: Date.today, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/index'
  end

  test 'should get close to expire in js' do
    fabricate_close_to_expire

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

  private

  def fabricate_expired
    3.times do
      Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end

    Fabricate(:loan, user_id: @user.id, expired_payments_count: 0)
    Fabricate(:loan, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
  end

  def fabricate_close_to_expire
    3.times { Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.tomorrow) }

    Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.yesterday)
    Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, next_payment_expire_at: Date.tomorrow)
    Fabricate(:loan, next_payment_expire_at: Date.tomorrow)
  end
end
