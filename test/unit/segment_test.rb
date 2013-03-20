require 'test_helper'

class SegmentTest < ActiveSupport::TestCase
  def setup
    @segment = Fabricate(:segment)
  end

  test 'create' do
    assert_difference ['Segment.count', 'Version.count'] do
      @segment = Segment.create(Fabricate.attributes_for(:segment))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Segment.count' do
        assert @segment.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @segment.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Segment.count', -1) { @segment.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @segment.attr = ''
    
    assert @segment.invalid?
    assert_equal 1, @segment.errors.size
    assert_equal [error_message_from_model(@segment, :attr, :blank)],
      @segment.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_segment = Fabricate(:segment)
    @segment.attr = new_segment.attr

    assert @segment.invalid?
    assert_equal 1, @segment.errors.size
    assert_equal [error_message_from_model(@segment, :attr, :taken)],
      @segment.errors[:attr]
  end
end
