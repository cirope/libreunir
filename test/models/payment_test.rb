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
        assert @payment.update_attributes(loan_id: 1)
      end
    end

    assert_equal 1, @payment.reload.loan_id
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Payment.count', -1) { @payment.destroy }
    end
  end

  test 'validates blank attributes' do
    @payment.loan_id = ''

    assert @payment.invalid?
    assert_equal 1, @payment.errors.size
    assert_equal [error_message_from_model(@payment, :loan_id, :blank)],
      @payment.errors[:loan_id]
  end

  test 'should calculate late days for a payment' do
    @payment = Fabricate(:payment, expiration_date: 2.month.ago)

    assert_equal '61 dias tarde', @payment.late_days
  end

  test 'should calculate average late days with bad payments' do
    5.times { @payment = Fabricate(:payment, expiration_date: 1.month.ago) }

    assert_equal '31 dias tarde', @payment.late_average
  end

  test 'should calculate average late days with good payments' do
    5.times { @payment = Fabricate(:payment, expiration_date: Date.today, payment_date: 1.month.ago) }

    assert_equal '31 dias antes', @payment.late_average
  end

  test 'should calculate average late days with average payments' do
    2.times { Fabricate(:payment, expiration_date: 2.month.ago, payment_date: 1.month.ago) }
    2.times { Fabricate(:payment, expiration_date: 1.month.ago, payment_date: 1.month.ago) }
    @payment = Fabricate(:payment, expiration_date: Date.today)

    assert_equal 'A tiempo', @payment.late_average
  end
end
