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
        restriction: I18n.l(Time.zone.now, format: :minimal)
      )
    ], @schedule.errors[:scheduled_at]
  end

  test 'toggle done' do
    assert !@schedule.done
    assert @schedule.toggle_done
    assert @schedule.done
  end

  test 'can not set to undone if in the past' do
    assert @schedule.toggle_done
    assert @schedule.done
    assert @schedule.update_column(:scheduled_at, 1.minute.ago)
    assert !@schedule.toggle_done
    assert @schedule.reload.done
  end

  test 'doable' do
    assert @schedule.doable?
    assert @schedule.toggle_done
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

  test 'count by days' do
    3.times { Fabricate(:schedule, scheduled_at: 3.days.from_now) }

    counts = Schedule.count_by_days

    assert_equal 1, counts[1.day.from_now.utc.at_beginning_of_day]
    assert_equal 3, counts[3.day.from_now.utc.at_beginning_of_day]
  end

  test 'for date' do
    3.times { Fabricate(:schedule, scheduled_at: 3.days.from_now) }

    assert_equal 3, Schedule.for_date(3.days.from_now.to_date).count
  end
end
