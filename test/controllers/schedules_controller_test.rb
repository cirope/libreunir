require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @schedule = Fabricate(:schedule)
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedules)
    assert_select '#unexpected_error', false
    assert_template 'schedules/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/new'
  end

  test 'should create schedule' do
    assert_difference ['Schedule.count', '@user.schedules.count'] do
      post :create, schedule: Fabricate.attributes_for(:schedule).slice(
        :description, :scheduled_at, :lock_version
      )
    end

    assert_redirected_to schedule_url(assigns(:schedule))
  end

  test 'should show schedule' do
    get :show, id: @schedule
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/show'
  end

  test 'should show schedule in js' do
    get :show, id: @schedule, format: :js
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/show'
    assert_equal :js, @request.format.symbol
  end

  test 'should get edit' do
    get :edit, id: @schedule
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/edit'
  end

  test 'should get edit in js' do
    get :edit, id: @schedule, format: :js
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/edit'
    assert_equal :js, @request.format.symbol
  end

  test 'should update schedule' do
    put :update, id: @schedule, 
      schedule: Fabricate.attributes_for(:schedule, attr: 'value')
    assert_redirected_to schedule_url(assigns(:schedule))
  end
end
