require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  def setup
    @loan = Fabricate(:loan)
  end

  test 'create' do
    assert_difference 'Loan.count' do
      @loan = Loan.create(Fabricate.attributes_for(:loan))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Loan.count' do
        assert @loan.update_attributes(approved_at: 5.days.ago.to_date)
      end
    end

    assert_equal 5.days.ago.to_date, @loan.reload.approved_at
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Loan.count', -1) { @loan.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @loan.loan_id = ''
    
    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :loan_id, :blank)],
      @loan.errors[:loan_id]
  end
    
  test 'validates unique attributes' do
    new_loan = Fabricate(:loan)
    @loan.loan_id = new_loan.loan_id

    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :loan_id, :taken)],
      @loan.errors[:loan_id]
  end

  test 'not expired' do
    assert_difference 'Loan.not_expired.count' do
      Fabricate(:loan, expired_payments_count: 0)
    end
  end

  test 'expired' do
    assert_difference 'Loan.expired.count' do
      Fabricate(:loan, expired_payments_count: 1)
    end
  end
end
