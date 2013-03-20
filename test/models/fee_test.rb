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
end
