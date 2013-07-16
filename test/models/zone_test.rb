require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  def setup
    @zone = Fabricate(:zone)
  end

  test 'create' do
    assert_difference 'Zone.count' do
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
    @zone.zone_id = ''
    @zone.branch_id = nil
    
    assert @zone.invalid?
    assert_equal 3, @zone.errors.size
    assert_equal [error_message_from_model(@zone, :name, :blank)],
      @zone.errors[:name]
    assert_equal [error_message_from_model(@zone, :zone_id, :blank)],
      @zone.errors[:zone_id]
    assert_equal [error_message_from_model(@zone, :branch_id, :blank)],
      @zone.errors[:branch_id]
  end
    
  test 'validates unique attributes' do
    new_zone = Fabricate(:zone)
    @zone.name = new_zone.name
    @zone.zone_id = new_zone.zone_id
    @zone.branch_id = new_zone.branch_id

    assert @zone.invalid?
    assert_equal 1, @zone.errors.size
    assert_equal [error_message_from_model(@zone, :name, :taken)],
      @zone.errors[:name]
  end
end
