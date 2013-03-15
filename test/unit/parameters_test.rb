require 'test_helper'

class ParametersTest < ActiveSupport::TestCase
  def setup
    @parameter = Fabricate(:parameter)
  end

  test 'create' do
    assert_difference ['Parameters.count', 'Version.count'] do
      @parameter = Parameters.create(Fabricate.attributes_for(:parameter))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Parameters.count' do
        assert @parameter.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @parameter.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Parameters.count', -1) { @parameter.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @parameter.attr = ''
    
    assert @parameter.invalid?
    assert_equal 1, @parameter.errors.size
    assert_equal [error_message_from_model(@parameter, :attr, :blank)],
      @parameter.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_parameter = Fabricate(:parameter)
    @parameter.attr = new_parameter.attr

    assert @parameter.invalid?
    assert_equal 1, @parameter.errors.size
    assert_equal [error_message_from_model(@parameter, :attr, :taken)],
      @parameter.errors[:attr]
  end
end
