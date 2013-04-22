require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  def setup
    @payment = Fabricate(:payment)
  end

  test 'create' do
    assert_difference ['Payment.count'] do
      @payment = Payment.create(Fabricate.attributes_for(:payment))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Payment.count' do
        assert @payment.update_attributes(expired_at: Date.today)
      end
    end

    assert_equal Date.today, @payment.reload.expired_at
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Payment.count', -1) { @payment.destroy }
    end
  end

  test 'validates blank attributes' do
    @payment.number = ''
    @payment.expired_at = ''
    @payment.loan_id = nil

    assert @payment.invalid?
    assert_equal 3, @payment.errors.size
    assert_equal [error_message_from_model(@payment, :number, :blank)],
      @payment.errors[:number]
    assert_equal [error_message_from_model(@payment, :expired_at, :blank)],
      @payment.errors[:expired_at]
    assert_equal [error_message_from_model(@payment, :loan_id, :blank)],
      @payment.errors[:loan_id]
  end

  test 'expired' do
    @payment.expired_at = Date.yesterday

    assert @payment.expired?

    @payment.expired_at = Date.tomorrow

    assert !@payment.expired?
  end

  test 'pending' do
    assert_difference 'Payment.pending.count' do
      Fabricate(:payment, paid_at: nil)
    end
  end

  test 'expire before' do
    assert_difference 'Payment.expire_before(Date.today).count' do
      Fabricate(:payment, expired_at: Date.yesterday)
    end
  end

  test 'expire after' do
    assert_difference 'Payment.expire_after(Date.today).count' do
      Fabricate(:payment, expired_at: Date.tomorrow)
    end
  end
end
