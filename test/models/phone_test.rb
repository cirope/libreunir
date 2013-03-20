require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  def setup
    @phone = Fabricate(:phone)
  end

  test 'create' do
    assert_difference ['Phone.count'] do
      @phone = Phone.create(Fabricate.attributes_for(:phone))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Phone.count' do
        assert @phone.update_attributes(phone: 'Updated')
      end
    end

    assert_equal 'Updated', @phone.reload.phone
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Phone.count', -1) { @phone.destroy }
    end
  end

  test 'validates blank attributes' do
    @phone.client_id = ''

    assert @phone.invalid?
    assert_equal 1, @phone.errors.size
    assert_equal [error_message_from_model(@phone, :client_id, :blank)],
      @phone.errors[:client_id]
  end

  test 'validates unique attributes' do
    new_phone = Fabricate(:phone)
    @phone.phone = new_phone.phone

    assert @phone.invalid?
    assert_equal 1, @phone.errors.size
    assert_equal [error_message_from_model(@phone, :phone, :taken)],
      @phone.errors[:phone]
  end
end
