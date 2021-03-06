require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def setup
    @schedule = Fabricate(:schedule)
  end

  test 'create' do
    assert_difference 'Schedule.count' do
      @schedule = Schedule.create(Fabricate.attributes_for(:schedule))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Schedule.count' do
        assert @schedule.update_attributes(description: 'Updated')
      end
    end

    assert_equal 'Updated', @schedule.reload.description
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Schedule.count', -1) { @schedule.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @schedule.description = ''
    @schedule.scheduled_at = nil
    @schedule.user_id = nil
    
    assert @schedule.invalid?
    assert_equal 3, @schedule.errors.size
    assert_equal [error_message_from_model(@schedule, :description, :blank)],
      @schedule.errors[:description]
    assert_equal [error_message_from_model(@schedule, :scheduled_at, :blank)],
      @schedule.errors[:scheduled_at]
    assert_equal [error_message_from_model(@schedule, :user_id, :blank)],
      @schedule.errors[:user_id]
  end

  test 'validates date attributes' do
    @schedule.scheduled_at = 1.hour.ago

    assert @schedule.invalid?
    assert_equal 1, @schedule.errors.size
    assert_equal [
      error_message_from_model(
        @schedule, :scheduled_at, :on_or_after,
        restriction: I18n.l(Time.zone.now, format: :minimal)
      )
    ], @schedule.errors[:scheduled_at]
  end

  test 'mark as done and mark as pending' do
    assert !@schedule.done
    assert @schedule.mark_as_done
    assert @schedule.done
    assert @schedule.mark_as_pending
    assert !@schedule.done
  end

  test 'can not set to undone if in the past' do
    assert @schedule.mark_as_done
    assert @schedule.done
    assert @schedule.update_column(:scheduled_at, 1.minute.ago)
    assert !@schedule.mark_as_done
    assert @schedule.reload.done
  end

  test 'doable' do
    assert @schedule.doable?
    assert @schedule.mark_as_done
    assert @schedule.doable?
    assert @schedule.update_column(:scheduled_at, 1.minute.ago)
    assert !@schedule.doable?
  end

  test 'past' do
    @schedule.scheduled_at = 1.minute.from_now
    assert !@schedule.past?

    @schedule.scheduled_at = 1.minute.ago
    assert @schedule.past?
  end

  test 'editable?' do
    assert @schedule.editable?

    @schedule.mark_as_done
    assert !@schedule.editable?

    @schedule.scheduled_at = 1.minute.ago
    assert !@schedule.editable?
  end

  test 'remind me' do
    assert_difference '@schedule.reminders.count' do
      @schedule.remind_me = true
      assert @schedule.save
    end

    assert_difference '@schedule.reminders.count', -1 do
      @schedule.remind_me = false
      assert @schedule.save
    end

    @schedule.remind_me = true
    @schedule.save

    assert_no_difference '@schedule.reminders.count' do
      @schedule.move(5.days.from_now)
      assert @schedule.reminders.reload.all? do |s|
        s.remind_at == (@schedule.scheduled_at - @schedule.delay)
      end
    end
  end

  test 'allow remind me' do
    assert @schedule.allow_remind_me?

    Fabricate(:reminder, schedule_id: @schedule.id, scheduled: true)

    assert !@schedule.reload.allow_remind_me?

    @schedule.reminders.clear
    @schedule.scheduled_at = 1.minute.ago

    assert !@schedule.allow_remind_me?

    @schedule.scheduled_at = 1.minute.from_now
    assert @schedule.allow_remind_me?
  end

  test 'delivery' do
    user = Fabricate(:user)
    2.times { Fabricate(:schedule, user_id: @schedule.user_id) }
    3.times { Fabricate(:schedule, user_id: user.id) }

    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      Reminder.send_summaries
    end
  end

  test 'move' do
    date = 5.days.from_now
    @schedule.move(date)

    assert_equal date.to_date, @schedule.reload.scheduled_at.to_date
  end

  test 'pending past' do
    user = Fabricate(:user)
    3.times do
      Fabricate(:schedule, user_id: user.id).update_column(:scheduled_at, 2.days.ago)
    end

    assert_equal 3, user.schedules.past.count
  end

  test 'pending future' do
    user = Fabricate(:user)
    3.times do
      Fabricate(:schedule, user_id: user.id, scheduled_at: 2.days.from_now)
    end

    assert_equal 3, user.schedules.future.count
  end
end
