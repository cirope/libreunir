require 'test_helper'

class SchedulesTest < ActionDispatch::IntegrationTest
  setup do
    @user = Fabricate(:user, password: '123456', role: :normal)
  end

  test 'should get schedules and mark all as done' do
    3.times { Fabricate(:schedule, user_id: @user.id, scheduled_at: 1.hour.from_now) }
    login(user: @user)

    visit schedules_path

    click_link Schedule.model_name.human(count: 0)
    assert page.has_css?('.main-page')

    within '.navtags' do
      click_link I18n.t('label.select')
      assert page.has_css?('li.open')

      click_link I18n.t('label.all')
    end

    click_link I18n.t('label.actions')

    assert_difference 'Schedule.done.count', 3 do
      find('[data-mark-action="mark_as_done"]').click

      assert page.has_css?('.strike')
    end
  end

  test 'should get schedules and mark all as pending' do
    3.times { Fabricate(:schedule, user_id: @user.id, done: true, scheduled_at: 1.hour.from_now) }
    login(user: @user)

    visit schedules_path

    click_link Schedule.model_name.human(count: 0)
    assert page.has_css?('.main-page')

    within '.navtags' do
      click_link I18n.t('label.select')
      assert page.has_css?('li.open')

      click_link I18n.t('label.all')
    end

    click_link I18n.t('label.actions')

    assert_difference 'Schedule.done.count', -3 do
      find('[data-mark-action="mark_as_pending"]').click

      assert page.has_no_css?('.strike')
    end
  end

  test 'should change monthly schedules' do
    Fabricate(:schedule, user_id: @user.id, scheduled_at: 1.month.from_now)
    login(user: @user)

    visit schedules_path

    find('.ui-datepicker-next').click

    assert page.has_css?('.has_event')
    assert_equal 1, all('.has_event').size
  end

  test 'should change daily schedules' do
    schedule = Fabricate(:schedule, user_id: @user.id)
    login(user: @user)

    visit schedules_path

    within '.ui-datepicker-calendar' do
      click_link schedule.scheduled_at.day
    end

    assert page.has_css?('.has_event')
    assert_equal 1, all('.has_event').size
  end

  test 'should create schedule' do
    schedule = Fabricate.build(:schedule, scheduled_at: 1.hour.from_now)
    login(user: @user)

    visit schedules_path

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

    visit schedules_path

    assert page.has_no_css?('#schedule_modal')

    within "[data-schedule-id=\"#{schedule.to_param}\"]" do
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
