require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  def setup
    @loan = Fabricate(:loan)
  end

  test 'create' do
    assert_difference ['Loan.count'] do
      @loan = Loan.create(Fabricate.attributes_for(:loan))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Loan.count' do
        assert @loan.update_attributes(order_id: 1)
      end
    end

    assert_equal 1, @loan.reload.order_id
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Loan.count', -1) { @loan.destroy }
    end
  end

  test 'validates blank attributes' do
    @loan.order_id = ''

    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :order_id, :blank)],
      @loan.errors[:order_id]
  end
end
