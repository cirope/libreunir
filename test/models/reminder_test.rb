require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  def setup
    @reminder = Fabricate(:reminder)
  end

  test 'create' do
    assert_difference 'Reminder.count' do
      @reminder = Reminder.create(Fabricate.attributes_for(:reminder))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Reminder.count' do
        assert @reminder.update_attributes(
          remind_at: @reminder.scheduled_at + 5.hours
        )
      end
    end

    assert_equal @reminder.scheduled_at + 5.hours, @reminder.remind_at
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Reminder.count', -1) { @reminder.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @reminder.remind_at = nil
    @reminder.kind = ''
    
    assert @reminder.invalid?
    assert_equal 2, @reminder.errors.size
    assert_equal [error_message_from_model(@reminder, :remind_at, :blank)],
      @reminder.errors[:remind_at]
    assert_equal [error_message_from_model(@reminder, :kind, :blank)],
      @reminder.errors[:kind]
  end

  test 'validates attributes length' do
    @reminder.kind = 'abcde' * 52

    assert @reminder.invalid?
    assert_equal 2, @reminder.errors.size
    assert_equal [
      error_message_from_model(@reminder, :kind, :too_long, count: 255),
      error_message_from_model(@reminder, :kind, :inclusion)
    ].sort, @reminder.errors[:kind].sort
  end

  test 'validates date and time attributes' do
    @reminder.remind_at = '13/13/13'

    assert @reminder.invalid?
    assert_equal 2, @reminder.errors.size
    assert_equal [
      error_message_from_model(@reminder, :remind_at, :blank),
      error_message_from_model(@reminder, :remind_at, :invalid_datetime),
    ].sort, @reminder.errors[:remind_at].sort

    @reminder.remind_at = @reminder.scheduled_at - 1.minute

    assert @reminder.invalid?
    assert_equal 1, @reminder.errors.size
    assert_equal [
      error_message_from_model(
        @reminder, :remind_at, :on_or_after,
        restriction: I18n.l(@reminder.scheduled_at, format: :minimal)
      ),
    ], @reminder.errors[:remind_at]
  end

  test 'delivery' do
    schedule = Fabricate(:schedule)
    reminder_options = { schedule_id: schedule.id }

    schedule.update_column :scheduled_at, 1.day.ago

    Fabricate(:reminder, reminder_options.merge(remind_at: 1.hour.from_now)) # Too far away
    Fabricate(:reminder, reminder_options.merge(remind_at: 1.minute.from_now, notified: true)) # Already notified
    Fabricate(:reminder, reminder_options.merge(remind_at: 1.minute.from_now)) # This must be sended
    Fabricate(:reminder, reminder_options.merge(remind_at: 1.minute.ago)) # This also must be sended

    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      Reminder.send_reminders
    end
  end
end
