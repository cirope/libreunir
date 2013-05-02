# encoding: utf-8

require 'test_helper'

class LoansTest < ActionDispatch::IntegrationTest
  test 'should get loans with close to expire' do
    user = Fabricate(:user, password: '123456')
    3.times { Fabricate(:loan, user_id: user.id, next_payment_expire_at: Date.tomorrow) }

    login(user: user)

    click_link I18n.t('menu.loans')
    click_link I18n.t('view.loans.close_to_expire')

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end

  test 'should get loans with expired' do
    user = Fabricate(:user, password: '123456')
    3.times do
      Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end

    login(user: user)

    click_link I18n.t('menu.loans')
    click_link I18n.t('view.loans.expired')

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end
end
