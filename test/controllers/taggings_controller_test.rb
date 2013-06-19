require 'test_helper'

class TaggingsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    @tag = Fabricate(:tag, user_id: @user.id)

    sign_in @user
  end

  test "should create tagging" do
    loan_ids = []
    2.times { loan_ids << Fabricate(:loan).id }

    assert_difference 'Tagging.count', 2 do
      xhr :post, :create, tag_id: @tag.id, loan_ids: loan_ids, format: :js
    end

    assert_response :success
    assert_not_nil assigns(:tag)
    assert_equal 2, @tag.loans.count
    assert_template 'taggings/reload'
  end

  test "should destroy tagging" do
    loan = Fabricate(:loan)
    tagging = loan.taggings.create(tag_id: @tag.id)

    assert_difference 'Tagging.count', -1 do
      xhr :post, :destroy, id: tagging.id, tag_id: @tag.id, format: :js
    end

    assert_response :success
    assert_not_nil assigns(:tag)
    assert_equal 0, @tag.loans.count
    assert_template 'taggings/reload'
  end
end
