require 'test_helper'

class LoansControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get expired' do
    fabricate_expired

    xhr :get, :expired, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/_expired'
  end

  test 'should get close to expire' do
    fabricate_close_to_expire

    xhr :get, :close_to_expire, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/_close_to_expire'
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
      Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, delayed_at: 2.days.ago.to_date)
    end

    Fabricate(:loan, user_id: @user.id, expired_payments_count: 0)
  end

  def fabricate_close_to_expire
    3.times { Fabricate(:loan, user_id: @user.id) }

    Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, progress: 8, days_overdue_average: 8)
  end
end
