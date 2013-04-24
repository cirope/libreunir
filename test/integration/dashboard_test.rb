# encoding: utf-8

require 'test_helper'

class DashboardTest < ActionDispatch::IntegrationTest
  test 'should get dashboard with close to expire tab' do
    user = Fabricate(:user, password: '123456')
    3.times { Fabricate(:loan, user_id: user.id, next_payment_expire_at: Date.tomorrow) }

    login(user: user)

    assert_equal dashboard_path, current_path

    click_link I18n.t('view.loans.close_to_expire')

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end

  test 'should get dashboard with expired tab' do
    user = Fabricate(:user, password: '123456')
    3.times do
      Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end

    login(user: user)

    assert_equal dashboard_path, current_path

    click_link I18n.t('view.loans.expired')

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end
end
