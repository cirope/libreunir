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

  test 'should get dashboard with schedules' do
    user = Fabricate(:user, password: '123456', role: :normal)

    3.times { Fabricate(:schedule, user_id: user.id, scheduled_at: 1.hour.from_now) }
    Fabricate(:schedule)

    login(user: user)

    assert_equal dashboard_path, current_path

    click_link Schedule.model_name.human(count: 0)

    assert page.has_css?('#schedules ul')
    assert_equal 3, all('#schedules ul li').size
  end

  test 'should get dashboard with schedules and mark as done one' do
    user = Fabricate(:user, password: '123456', role: :normal)

    3.times { Fabricate(:schedule, user_id: user.id, scheduled_at: 1.hour.from_now) }

    login(user: user)

    assert_equal dashboard_path, current_path

    click_link Schedule.model_name.human(count: 0)

    assert page.has_css?('#schedules ul')
    
    within '#schedules ul' do
      assert_difference 'Schedule.done.count' do
        assert page.has_no_css?('.strike')

        find('li:first-child input[data-toggle-schedule-done]').click

        assert page.has_css?('.strike')
      end
    end
  end
end
