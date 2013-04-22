require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Fabricate(:product)
  end

  test 'create' do
    assert_difference 'Product.count' do
      @product = Product.create(Fabricate.attributes_for(:product))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Product.count' do
        assert @product.update_attributes(delay_date: Date.yesterday)
      end
    end

    assert_equal Date.yesterday, @product.reload.delay_date
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Product.count', -1) { @product.destroy }
    end
  end

  test 'validates blank attributes' do
    @product.product_id = nil

    assert @product.invalid?
    assert_equal 1, @product.errors.size
    assert_equal [error_message_from_model(@product, :product_id, :blank)],
      @product.errors[:product_id]
  end

  test 'validates unique attributes' do
    new_product = Fabricate(:product)
    @product.product_id = new_product.product_id

    assert @product.invalid?
    assert_equal 1, @product.errors.size
    assert_equal [error_message_from_model(@product, :product_id, :taken)],
      @product.errors[:product_id]
  end
end
