require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  def setup
    @payment = Fabricate(:payment)
  end

  test 'create' do
    assert_difference ['Payment.count', 'Version.count'] do
      @payment = Payment.create(Fabricate.attributes_for(:payment))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Payment.count' do
        assert @payment.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @payment.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Payment.count', -1) { @payment.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @payment.attr = ''
    
    assert @payment.invalid?
    assert_equal 1, @payment.errors.size
    assert_equal [error_message_from_model(@payment, :attr, :blank)],
      @payment.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_payment = Fabricate(:payment)
    @payment.attr = new_payment.attr

    assert @payment.invalid?
    assert_equal 1, @payment.errors.size
    assert_equal [error_message_from_model(@payment, :attr, :taken)],
      @payment.errors[:attr]
  end
end
