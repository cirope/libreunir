require 'test_helper'

class SchedulesTest < ActionDispatch::IntegrationTest
  setup do
    @user = Fabricate(:user, password: '123456', role: :normal)
  end

  test 'should get schedules and mark as done one' do
    3.times { Fabricate(:schedule, user_id: @user.id, scheduled_at: 1.hour.from_now) }
    login(user: @user)

    click_link Schedule.model_name.human(count: 0)

    assert page.has_css?('[data-calendar-day] ul')
    
    within '[data-calendar-day] ul' do
      assert_difference 'Schedule.done.count' do
        assert page.has_no_css?('.strike')

        find('li:first-child input[data-toggle-schedule-done]').click

        assert page.has_css?('.strike')
      end
    end
  end

  test 'should change monthly schedules' do
    login(user: @user)

    Fabricate(:schedule, user_id: @user.id, scheduled_at: 1.month.from_now)

    find('.ui-datepicker-next').click

    assert page.has_css?('.has_event')
    assert_equal 1, all('.has_event').size
  end

  test 'should change daily schedules' do
    schedule = Fabricate(:schedule, user_id: @user.id)
    login(user: @user)

    within '.ui-datepicker-calendar' do
      click_link schedule.scheduled_at.day 
    end

    assert page.has_css?('.has_event')
    assert_equal 1, all('.has_event').size
  end

  test 'should create schedule' do
    schedule = Fabricate.build(:schedule)

    login(user: @user)

    assert page.has_no_css?('#schedule_modal')
    assert page.has_css?('.btn-primary')

    find('.btn-primary').click

    assert page.has_css?('#schedule_modal')

    assert_difference 'Schedule.count' do
      within '[data-schedule-modal]' do
        click_link schedule.scheduled_at.day

        fill_in 'schedule_description', with: schedule.description

        find('.btn-primary').click
      end

      assert page.has_css?('.has_event')
      assert_equal 1, all('.has_event').size
    end
  end

  test 'should edit schedule' do
    schedule = Fabricate(:schedule, user_id: @user.id, scheduled_at: 1.hour.from_now)
    schedule_attrs = Fabricate.attributes_for(:schedule)

    login(user: @user)

    assert page.has_no_css?('#schedule_modal')

    within "li[data-schedule-id=\"#{schedule.to_param}\"]" do
      click_link '✎'
    end

    assert page.has_css?('#schedule_modal')

    assert_no_difference 'Schedule.count' do
      within '[data-schedule-modal]' do
        find('.ui-datepicker-next').click
        fill_in 'schedule_description', with: schedule_attrs[:description]

        find('.btn-primary').click
      end
    end

    assert page.has_css?('.has_event')
    assert_equal 1, all('.has_event').size
    assert_equal schedule_attrs[:description], schedule.reload.description
  end
end
