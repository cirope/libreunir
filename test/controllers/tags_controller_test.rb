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
      post :create, tag: Fabricate.attributes_for(:tag)
    end

    assert_redirected_to tag_url(assigns(:tag))
  end

  test "should get edit" do
    get :edit, id: @tag
    assert_response :success
    assert_not_nil assigns(:tag)
    assert_select '#unexpected_error', false
    assert_template "tags/edit"
  end

  test "should update tag" do
    put :update, id: @tag, 
      tag: Fabricate.attributes_for(:tag, attr: 'value')
    assert_redirected_to tag_url(assigns(:tag))
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_redirected_to tags_path
  end
end