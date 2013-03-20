require 'test_helper'

class CallTest < ActiveSupport::TestCase
  def setup
    @call = Fabricate(:call)
  end

  test 'create' do
    assert_difference ['Call.count'] do
      @call = Call.create(Fabricate.attributes_for(:call))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Call.count' do
        assert @call.update_attributes(call: 'Updated')
      end
    end

    assert_equal 'Updated', @call.reload.call
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Call.count', -1) { @call.destroy }
    end
  end

  test 'validates blank attributes' do
    @call.call = ''

    assert @call.invalid?
    assert_equal 1, @call.errors.size
    assert_equal [error_message_from_model(@call, :call, :blank)],
      @call.errors[:call]
  end

  test 'validates unique attributes' do
    new_call = Fabricate(:call)
    @call.call = new_call.call

    assert @call.invalid?
    assert_equal 1, @call.errors.size
    assert_equal [error_message_from_model(@call, :call, :taken)],
      @call.errors[:call]
  end
end
