require 'test_helper'

class AdviserTest < ActiveSupport::TestCase
  def setup
    @adviser = Fabricate(:adviser)
  end

  test 'create' do
    assert_difference ['Adviser.count'] do
      @adviser = Adviser.create(Fabricate.attributes_for(:adviser))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Adviser.count' do
        assert @adviser.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @adviser.reload.name
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Adviser.count', -1) { @adviser.destroy }
    end
  end

  test 'validates blank attributes' do
    @adviser.name = ''

    assert @adviser.invalid?
    assert_equal 1, @adviser.errors.size
    assert_equal [error_message_from_model(@adviser, :name, :blank)],
      @adviser.errors[:name]
  end

  test 'validates unique attributes' do
    new_adviser = Fabricate(:adviser)
    @adviser.name = new_adviser.name

    assert @adviser.invalid?
    assert_equal 1, @adviser.errors.size
    assert_equal [error_message_from_model(@adviser, :name, :taken)],
      @adviser.errors[:name]
  end
end
