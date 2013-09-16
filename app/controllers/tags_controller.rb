class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_parent, only: [:create, :new]

  check_authorization
  load_and_authorize_resource through: :current_scope

  layout ->(c) { c.request.xhr? ? false : 'application' }

  respond_to :html, :js

  # GET /tags
  def index
    @title = t('view.tags.index_title')
  end

  # GET /tags/new
  def new
  end

  # GET /tags/1/edit
  def edit
    @title = t('view.tags.edit_title')
  end

  # POST /tags
  def create
    @tag.parent_id = @parent.id if @parent
    @tag.user_id = current_user.id
    @tag.branch_id = selected_user.branch.id

    @tag.save
  end

  # PUT /tags/1
  def update
    @tag.update(tag_params)

    respond_to do |format|
      format.js
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy

    respond_to do |format|
      format.js
    end
  end

  private
    def tag_params
      params.require(:tag).permit(:name, :category, :parent_id)
    end

    def load_parent
      @parent = Tag.find_by(id: params[:tag_id])
    end
end
