class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_current_user, only: [:edit_profile, :update_profile]

  check_authorization
  load_and_authorize_resource

  # GET /users
  def index
    @title = t 'view.users.index_title'
    @searchable = true
    @users = @users.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /users/1
  def show
    @title = t 'view.users.show_title'
  end

  # GET /users/new
  def new
    @title = t 'view.users.new_title'

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @title = t 'view.users.edit_title'
  end

  # POST /users
  def create
    @title = t 'view.users.new_title'

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('view.users.correctly_created') }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /users/1
  def update
    authorize! :assign_roles, @user if user_params[:roles]
    @title = t 'view.users.edit_title'

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: t('view.users.correctly_updated') }
      else
        format.html { render action: 'edit' }
      end
    end

  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.users.stale_object_error'
    redirect_to edit_user_url(@user)
  end

  # GET /users/1/edit_profile
  def edit_profile
    @title = t('view.users.edit_profile')
  end

  # PUT /users/1/update_profile
  def update_profile
    @title = t('view.users.edit_profile')

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(edit_profile_user_url(@user), notice: t('view.users.profile_correctly_updated')) }
      else
        format.html { render action: 'edit_profile' }
      end
    end

  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.users.stale_object_error')
    redirect_to edit_profile_user_url(@user)
  end

  # DELETE /users/1
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  private

  def load_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :username, :password, :password_confirmation, :role, :remember_me, :lock_version
    )
  end
end
