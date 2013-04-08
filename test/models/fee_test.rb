require 'test_helper'

class FeeTest < ActiveSupport::TestCase
  def setup
    @fee = Fabricate(:fee)
  end

  test 'create' do
    assert_difference ['Fee.count'] do
      @fee = Fee.create(Fabricate.attributes_for(:fee))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Fee.count' do
        assert @fee.update_attributes(loan_id: 1)
      end
    end

    assert_equal 1, @fee.reload.loan_id
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Fee.count', -1) { @fee.destroy }
    end
  end

  test 'validates blank attributes' do
    @fee.loan_id = ''

    assert @fee.invalid?
    assert_equal 1, @fee.errors.size
    assert_equal [error_message_from_model(@fee, :loan_id, :blank)],
      @fee.errors[:loan_id]
  end

  test 'should calculate late days for a fee' do
    @fee = Fabricate(:fee, expiration_date: 2.month.ago)

    assert_equal '61 dias tarde', @fee.late_days
  end

  test 'should calculate average late days with bad fees' do
    5.times { @fee = Fabricate(:fee, expiration_date: 1.month.ago) }

    assert_equal '31 dias tarde', @fee.late_average
  end

  test 'should calculate average late days with good fees' do
    5.times { @fee = Fabricate(:fee, expiration_date: Date.today, payment_date: 1.month.ago) }

    assert_equal '31 dias antes', @fee.late_average
  end

  test 'should calculate average late days with average fees' do
    2.times { Fabricate(:fee, expiration_date: 2.month.ago, payment_date: 1.month.ago) }
    2.times { Fabricate(:fee, expiration_date: 1.month.ago, payment_date: 1.month.ago) }
    @fee = Fabricate(:fee, expiration_date: Date.today)

    assert_equal 'A tiempo', @fee.late_average
  end
end
