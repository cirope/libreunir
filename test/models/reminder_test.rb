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
end
