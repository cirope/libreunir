require 'test_helper'

class NotesControllerTest < ActionController::TestCase

  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get index' do
    schedule = Fabricate(:schedule, user_id: @user.id)
    3.times { Fabricate(:note, noteable_id: schedule.id, noteable_type: schedule.class.to_s) }

    get :index, schedule_id: schedule.id, format: :js
    assert_response :success
    assert_not_nil assigns(:notes)
    assert_equal 3, assigns(:notes).size
    assert_select '#unexpected_error', false
    assert_template 'notes/index'
  end

  test 'should create note' do
    schedule = Fabricate(:schedule, user_id: @user.id)

    assert_difference 'Note.count' do
      xhr :post, :create, schedule_id: schedule.id, note:
        Fabricate.attributes_for(
          :note, schedule_id: nil, schedule_type: nil
        ), format: :js
    end

    assert_response :success
    assert_not_nil assigns(:note)
    assert_select '#unexpected_error', false
    assert_template 'notes/create'
  end
end
