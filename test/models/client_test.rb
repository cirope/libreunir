require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Fabricate(:client)
  end

  test 'create' do
    assert_difference 'Client.count' do
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
    @client.lastname = ''
    @client.identification = ''

    assert @client.invalid?
    assert_equal 3, @client.errors.size
    assert_equal [error_message_from_model(@client, :name, :blank)],
      @client.errors[:name]
    assert_equal [error_message_from_model(@client, :lastname, :blank)],
      @client.errors[:lastname]
    assert_equal [error_message_from_model(@client, :identification, :blank)],
      @client.errors[:identification]
  end

  test 'validates unique attributes' do
    new_client = Fabricate(:client)
    @client.identification = new_client.identification

    assert @client.invalid?
    assert_equal 1, @client.errors.size
    assert_equal [error_message_from_model(@client, :identification, :taken)],
      @client.errors[:identification]
  end

  test 'should get last comments' do
    15.times { Fabricate(:comment, client_id: @client.id) }

    assert_equal 10, @client.last_comments.size
  end
end
