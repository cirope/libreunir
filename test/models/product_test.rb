require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Fabricate(:product)
  end

  test 'create' do
    assert_difference ['Product.count'] do
      @product = Product.create(Fabricate.attributes_for(:product))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Product.count' do
        assert @product.update_attributes(product_id: 'Updated')
      end
    end

    assert_equal 'Updated', @product.reload.product_id
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Product.count', -1) { @product.destroy }
    end
  end
end
