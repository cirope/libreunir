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

  test 'should get not renewed' do
    fabricate_canceled

    xhr :get, :not_renewed, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/_not_renewed'
  end

  test 'should get close to cancel' do
    fabricate_close_to_cancel

    xhr :get, :close_to_cancel, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/_close_to_cancel'
  end

  test 'should get capital' do
    fabricate_capital

    xhr :get, :capital, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/_capital'
  end

  test 'should get prevision' do
    fabricate_prevision

    xhr :get, :prevision, format: :js

    assert_response :success
    assert_equal 3, assigns(:loans).size
    assert_template 'loans/_prevision'
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

      Fabricate(:loan, user_id: @user.id, expired_payments_count: 1, progress: 8, canceled_at: Time.zone.now)
    end

    def fabricate_canceled
      3.times { Fabricate(:loan, user_id: @user.id, canceled_at: 3.days.ago.to_date) }

      Fabricate(:loan, user_id: @user.id)
    end

    def fabricate_close_to_cancel
      3.times {
        Fabricate(
          :loan, user_id: @user.id, debtor: true, expired_payments_count: 1, payments_to_expire_count: 1
        )
      }

      Fabricate(:loan, user_id: @user.id)
    end

    def fabricate_capital
      3.times { Fabricate(:loan, user_id: @user.id, debtor: true) }

      Fabricate(:loan, user_id: @user.id)
    end

    def fabricate_prevision
      3.times { Fabricate(:loan, user_id: @user.id, debtor: true, delayed_at: Date.today - 80) }

      Fabricate(:loan, user_id: @user.id)
    end
end
