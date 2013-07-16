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
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:days)
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
      post :create, format: :js,
        schedule: Fabricate.attributes_for(:schedule).slice(
        :description, :scheduled_at, :lock_version
      )
    end

    assert_redirected_to schedules_url(date: assigns(:schedule).scheduled_at.to_date)
  end

  test 'should show schedule' do
    get :show, id: @schedule, format: :js
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/show'
    assert_equal :js, @request.format.symbol
  end

  test 'should get edit' do
    get :edit, id: @schedule, format: :js
    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_select '#unexpected_error', false
    assert_template 'schedules/edit'
    assert_equal :js, @request.format.symbol
  end

  test 'should update schedule' do
    patch :update, id: @schedule, format: :js,
      schedule: Fabricate.attributes_for(:schedule, description: 'Updated').slice(
        :description, :scheduled_at, :lock_version
      )

    assert_redirected_to schedules_url(date: @schedule.scheduled_at.to_date)
    assert_equal 'Updated', @schedule.reload.description
  end

  test 'should toggle schedule done' do
    assert !@schedule.done

    put :toggle_done, id: @schedule, format: :js

    assert_response :success
    assert_not_nil assigns(:schedule)
    assert @schedule.reload.done
    assert_select '#unexpected_error', false
    assert_template 'schedules/toggle_done'
    assert_equal :js, @request.format.symbol
  end

  test 'should search schedule' do
    get :search, date: @schedule.scheduled_at.to_date, format: :js

    assert_response :success
    assert_not_nil assigns(:schedules)
    assert_not_nil assigns(:date)
    assert_equal 1, assigns(:schedules).size
    assert_select '#unexpected_error', false
    assert_template 'schedules/search'
    assert_equal :js, @request.format.symbol
  end
end
