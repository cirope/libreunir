# encoding: utf-8

require 'test_helper'

class SchedulesTest < ActionDispatch::IntegrationTest
  test 'should get schedules' do
    user = Fabricate(:user, password: '123456', role: :normal)

    3.times { Fabricate(:schedule, user_id: user.id, scheduled_at: 1.hour.from_now) }
    Fabricate(:schedule)

    login(user: user)

    assert page.has_css?('#schedules ul')
    assert_equal 3, all('#schedules ul li').size
  end

  test 'should get schedules and mark as done one' do
    user = Fabricate(:user, password: '123456', role: :normal)

    3.times { Fabricate(:schedule, user_id: user.id, scheduled_at: 1.hour.from_now) }

    login(user: user)

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
