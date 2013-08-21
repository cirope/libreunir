require 'test_helper'

class SegmentTest < ActiveSupport::TestCase
  def setup
    @segment = Fabricate(:segment)
  end

  test 'create' do
    assert_difference 'Segment.count' do
      @segment = Segment.create(Fabricate.attributes_for(:segment))
    end 
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Segment.count' do
        assert @segment.update_attributes(description: 'Updated')
      end
    end

    assert_equal 'Updated', @segment.reload.description
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Segment.count', -1) { @segment.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @segment.segment_id = ''
    @segment.description = '    '
    @segment.short_description = nil
    
    assert @segment.invalid?
    assert_equal 3, @segment.errors.size
    assert_equal [error_message_from_model(@segment, :segment_id, :blank)],
      @segment.errors[:segment_id]
    assert_equal [error_message_from_model(@segment, :description, :blank)],
      @segment.errors[:description]
    assert_equal [error_message_from_model(@segment, :short_description, :blank)],
      @segment.errors[:short_description]
  end
    
  test 'validates unique attributes' do
    new_segment = Fabricate(:segment)
    @segment.segment_id = new_segment.segment_id

    assert @segment.invalid?
    assert_equal 1, @segment.errors.size
    assert_equal [error_message_from_model(@segment, :segment_id, :taken)],
      @segment.errors[:segment_id]
  end
end
