require 'test_helper'

class AdviserTest < ActiveSupport::TestCase
  def setup
    @adviser = Fabricate(:adviser)
  end

  test 'create' do
    assert_difference ['Adviser.count', 'Version.count'] do
      @adviser = Adviser.create(Fabricate.attributes_for(:adviser))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Adviser.count' do
        assert @adviser.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @adviser.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Adviser.count', -1) { @adviser.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @adviser.attr = ''
    
    assert @adviser.invalid?
    assert_equal 1, @adviser.errors.size
    assert_equal [error_message_from_model(@adviser, :attr, :blank)],
      @adviser.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_adviser = Fabricate(:adviser)
    @adviser.attr = new_adviser.attr

    assert @adviser.invalid?
    assert_equal 1, @adviser.errors.size
    assert_equal [error_message_from_model(@adviser, :attr, :taken)],
      @adviser.errors[:attr]
  end
end
