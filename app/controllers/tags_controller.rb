class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent_tag, only: [:create, :new]
  
  check_authorization
  load_and_authorize_resource through: :current_user 

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
    @tag.path = @parent_tag.path if @parent_tag

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
    @tag.self_and_descendents.each do |child|
      child.destroy
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def set_parent_tag
    @parent_tag = Tag.find_by(id: params[:tag_id])
  end

  def tag_params
    params.require(:tag).permit(:name, :category)
  end
end
