require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Fabricate(:product)
  end

  test 'create' do
    assert_difference ['Product.count', 'Version.count'] do
      @product = Product.create(Fabricate.attributes_for(:product))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Product.count' do
        assert @product.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @product.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Product.count', -1) { @product.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @product.attr = ''
    
    assert @product.invalid?
    assert_equal 1, @product.errors.size
    assert_equal [error_message_from_model(@product, :attr, :blank)],
      @product.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_product = Fabricate(:product)
    @product.attr = new_product.attr

    assert @product.invalid?
    assert_equal 1, @product.errors.size
    assert_equal [error_message_from_model(@product, :attr, :taken)],
      @product.errors[:attr]
  end
end
