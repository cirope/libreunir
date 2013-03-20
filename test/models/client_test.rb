require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Fabricate(:client)
  end

  test 'create' do
    assert_difference ['Client.count'] do
      @client = Client.create(Fabricate.attributes_for(:client))
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Client.count' do
        assert @client.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @client.reload.name
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Client.count', -1) { @client.destroy }
    end
  end

  test 'validates blank attributes' do
    @client.name = ''

    assert @client.invalid?
    assert_equal 1, @client.errors.size
    assert_equal [error_message_from_model(@client, :name, :blank)],
      @client.errors[:name]
  end

  test 'validates unique attributes' do
    new_client = Fabricate(:client)
    @client.name = new_client.name

    assert @client.invalid?
    assert_equal 1, @client.errors.size
    assert_equal [error_message_from_model(@client, :name, :taken)],
      @client.errors[:name]
  end
end
