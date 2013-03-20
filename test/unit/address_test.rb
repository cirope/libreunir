require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  def setup
    @address = Fabricate(:address)
  end

  test 'create' do
    assert_difference ['Address.count', 'Version.count'] do
      @address = Address.create(Fabricate.attributes_for(:address))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Address.count' do
        assert @address.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @address.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Address.count', -1) { @address.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @address.attr = ''
    
    assert @address.invalid?
    assert_equal 1, @address.errors.size
    assert_equal [error_message_from_model(@address, :attr, :blank)],
      @address.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_address = Fabricate(:address)
    @address.attr = new_address.attr

    assert @address.invalid?
    assert_equal 1, @address.errors.size
    assert_equal [error_message_from_model(@address, :attr, :taken)],
      @address.errors[:attr]
  end
end
