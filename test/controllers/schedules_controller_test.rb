require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    @schedule = Fabricate(:schedule, user_id: @user.id)

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

  test 'should destroy schedule' do
    assert_difference 'Schedule.count', -1 do
      xhr :delete, :destroy, id: @schedule.id, format: :js
    end

    assert_response :success
    assert_not_nil assigns(:schedule)
    assert_equal 0, Schedule.count
    assert_template 'schedules/destroy'
  end

  test 'should get calendar' do
    xhr :get, :calendar, format: :js

    assert_response :success
    assert_not_nil assigns(:date)
    assert_select '#unexpected_error', false
    assert_template 'schedules/calendar'
  end

  test 'should mark schedule as done' do
    schedule_ids = []
    3.times { schedule_ids << Fabricate(:schedule, user_id: @user.id).id }

    xhr :put, :mark_as_done, schedule_ids: schedule_ids, format: :js

    assert_response :success
    assert_equal 3, assigns(:schedules_ids).count
    assigns(:schedules_ids).each { |s| assert s.reload.done }
    assert_select '#unexpected_error', false
    assert_template 'schedules/toggle_done'
    assert_equal :js, @request.format.symbol
  end

  test 'should mark schedule as pending' do
    schedule_ids = []
    3.times { schedule_ids << Fabricate(:schedule, user_id: @user.id, done: true).id }

    xhr :put, :mark_as_pending, schedule_ids: schedule_ids, format: :js

    assert_response :success
    assert_equal 3, assigns(:schedules_ids).count
    assigns(:schedules_ids).each { |s| assert !s.reload.done }
    assert_select '#unexpected_error', false
    assert_template 'schedules/toggle_done'
    assert_equal :js, @request.format.symbol
  end

  test 'should move the schedules to another date' do
    date = 3.days.from_now
    schedule_ids = []
    3.times { schedule_ids << Fabricate(:schedule, user_id: @user.id).id }

    xhr :put, :move, schedule_ids: schedule_ids, date: date.to_s(:db), format: :js

    assert_response :redirect
    assert_equal 3, assigns(:schedules_ids).count
    assigns(:schedules_ids).each do |s|
      assert_equal date.to_date, s.reload.scheduled_at.to_date
    end
    assert_select '#unexpected_error', false
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

  test 'should get schedules pending' do
    get :pending
    assert_response :success
    assert_not_nil assigns(:schedules)
    assert_select '#unexpected_error', false
    assert_template 'schedules/pending'
  end
end
