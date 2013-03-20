require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  def setup
    @address = Fabricate(:address)
  end

  test 'create' do
    assert_difference ['Address.count'] do
      @address = Address.create(Fabricate.attributes_for(:address))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Address.count' do
        assert @address.update_attributes(address: 'Updated')
      end
    end

    assert_equal 'Updated', @address.reload.address
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Address.count', -1) { @address.destroy }
    end
  end

  test 'validates blank attributes' do
    @address.address = ''

    assert @address.invalid?
    assert_equal 1, @address.errors.size
    assert_equal [error_message_from_model(@address, :address, :blank)],
      @address.errors[:address]
  end
end
