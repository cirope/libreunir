require 'test_helper'

class ParametersTest < ActiveSupport::TestCase
  def setup
    @parameter = Fabricate(:parameters)
  end

  test 'create' do
    assert_difference ['Parameters.count'] do
      @parameter = Parameters.create(Fabricate.attributes_for(:parameters))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Parameters.count' do
        assert @parameter.update_attributes(rate: 1)
      end
    end

    assert_equal 1, @parameter.reload.rate
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Parameters.count', -1) { @parameter.destroy }
    end
  end

  test 'validates blank attributes' do
    @parameter.rate = ''

    assert @parameter.invalid?
    assert_equal 1, @parameter.errors.size
    assert_equal [error_message_from_model(@parameter, :rate, :blank)],
      @parameter.errors[:rate]
  end
end
