require 'test_helper'

class TagsControllerTest < ActionController::TestCase

  setup do
    @tag = Fabricate(:tag)
    @user = Fabricate(:user)

    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
    assert_select '#unexpected_error', false
    assert_template "tags/index"
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, tag: Fabricate.attributes_for(:tag), format: :js
    end

    assert_response :success
    assert_not_nil assigns(:tag)
    assert_select '#unexpected_error', false
    assert_template "tags/create"
  end

  test "should get edit" do
    tag = Fabricate(:tag, user_id: @user.id)

    xhr :get, :edit, id: tag.id, format: :js

    assert_response :success
    assert_not_nil assigns(:tag)
    assert_select '#unexpected_error', false
    assert_template "tags/edit"
  end

  test "should update tag" do
    tag = Fabricate(:tag, user_id: @user.id)

    assert_no_difference 'Tag.count' do
      xhr :put, :update, id: tag.id,
        tag: Fabricate.attributes_for(:tag, name: 'new_value'), format: :js
    end

    assert_response :success
    assert_not_nil assigns(:tag)
    assert_select '#unexpected_error', false
    assert_template "tags/update"
  end

  test "should destroy tag" do
    tag = Fabricate(:tag, user_id: @user.id)

    assert_difference('Tag.count', -1) do
      xhr :delete, :destroy, id: tag.id, format: :js
    end

    assert_response :success
    assert_not_nil assigns(:tag)
    assert_select '#unexpected_error', false
    assert_template "tags/destroy"
  end
end
