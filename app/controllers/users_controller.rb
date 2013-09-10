class UsersController < ApplicationController
  include Users::Profile

  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource

  before_action :load_tenant, only: [:switch]

  # GET /users
  def index
    @title = t 'view.users.index_title'
    @searchable = true
    @users = @users.filtered_role(params[:role]).filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
    end
  end

  # GET /users/1
  def show
    @title = t 'view.users.show_title'
  end

  # GET /users/new
  def new
    @title = t 'view.users.new_title'
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

  # PATCH /users/1
  def update
    authorize! :assign_roles, @user if user_params[:role]
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

  # DELETE /users/1
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  def switch
    if current_user.can_show?(@tenant)
      session[:tenant_id] = @tenant.id
      redirect_to root_url
    else
      raise CanCan::AccessDenied
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :name, :email, :username, :password, :password_confirmation,
        :identification, :branch_id, :parent_id, :role, :remember_me, :lock_version
      )
    end

    def load_tenant
      @tenant = User.find_by(id: params[:tenant_id]) if params[:tenant_id].present?
    end
end
