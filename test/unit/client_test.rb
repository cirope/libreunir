require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Fabricate(:client)
  end

  test 'create' do
    assert_difference ['Client.count', 'Version.count'] do
      @client = Client.create(Fabricate.attributes_for(:client))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Client.count' do
        assert @client.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @client.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Client.count', -1) { @client.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @client.attr = ''
    
    assert @client.invalid?
    assert_equal 1, @client.errors.size
    assert_equal [error_message_from_model(@client, :attr, :blank)],
      @client.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_client = Fabricate(:client)
    @client.attr = new_client.attr

    assert @client.invalid?
    assert_equal 1, @client.errors.size
    assert_equal [error_message_from_model(@client, :attr, :taken)],
      @client.errors[:attr]
  end
end
