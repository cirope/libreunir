require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = Fabricate(:order)
  end

  test 'create' do
    assert_difference ['Order.count'] do
      @order = Order.create(Fabricate.attributes_for(:order))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Order.count' do
        assert @order.update_attributes(adviser_id: 'Updated')
      end
    end

    assert_equal 'Updated', @order.reload.adviser_id
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Order.count', -1) { @order.destroy }
    end
  end

  test 'validates blank attributes' do
    @order.adviser_id = ''

    assert @order.invalid?
    assert_equal 1, @order.errors.size
    assert_equal [error_message_from_model(@order, :adviser_id, :blank)],
      @order.errors[:adviser_id]
  end
end
