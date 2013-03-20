require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  def setup
    @zone = Fabricate(:zone)
  end

  test 'create' do
    assert_difference ['Zone.count'] do
      @zone = Zone.create(Fabricate.attributes_for(:zone))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Zone.count' do
        assert @zone.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @zone.reload.name
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Zone.count', -1) { @zone.destroy }
    end
  end

  test 'validates blank attributes' do
    @zone.name = ''

    assert @zone.invalid?
    assert_equal 1, @zone.errors.size
    assert_equal [error_message_from_model(@zone, :name, :blank)],
      @zone.errors[:name]
  end

  test 'validates unique attributes' do
    new_zone = Fabricate(:zone)
    @zone.name = new_zone.name

    assert @zone.invalid?
    assert_equal 1, @zone.errors.size
    assert_equal [error_message_from_model(@zone, :name, :taken)],
      @zone.errors[:name]
  end
end
