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
    assert_difference 'Version.count' do
      assert_no_difference 'Schedule.count' do
        assert @schedule.update_attributes(description: 'Updated')
      end
    end

    assert_equal 'Updated', @schedule.reload.description
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
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
        restriction: I18n.l(Time.now, format: :minimal)
      )
    ], @schedule.errors[:scheduled_at]
  end

  test 'toggle done' do
    assert !@schedule.done

    @schedule.toggle_done

    assert @schedule.done
  end
end
