class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only:  [:edit, :update, :destroy]
  
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
    redirect_to tags_url, notice: t('view.tags.correctly_destroyed')
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :category)
  end
end
