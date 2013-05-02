require 'test_helper'

class ClientsControllerTest < ActionController::TestCase

  setup do
    @user = Fabricate(:user)
    @client = Fabricate(:client)

    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
    assert_select '#unexpected_error', false
    assert_template "clients/index"
  end

  test 'should get filtered index' do
    Fabricate(:loan, user_id: @user.id, client_id: @client.id)

    3.times do 
      client = Fabricate(:client, name: 'in_filtered_index')
      Fabricate(:loan, user_id: @user.id, client_id: client.id)
    end

    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:clients)
    assert_equal 3, assigns(:clients).size
    assert assigns(:clients).all? { |u| u.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:clients).size, Client.count
    assert_select '#unexpected_error', false
    assert_template 'clients/index'
  end

  test "should get client" do
    loan = Fabricate(:loan, user_id: @user.id, client_id: @client.id)

    get :show, id: @client.to_param, format: :js
    assert_response :success
    assert_not_nil assigns(:client)
    assert_template "clients/show"
  end
end
