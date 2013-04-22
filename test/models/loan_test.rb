require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  def setup
    @loan = Fabricate(:loan)
  end

  test 'create' do
    assert_difference ['Loan.count', 'Version.count'] do
      @loan = Loan.create(Fabricate.attributes_for(:loan))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Loan.count' do
        assert @loan.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @loan.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Loan.count', -1) { @loan.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @loan.attr = ''
    
    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :attr, :blank)],
      @loan.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_loan = Fabricate(:loan)
    @loan.attr = new_loan.attr

    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :attr, :taken)],
      @loan.errors[:attr]
  end
end
