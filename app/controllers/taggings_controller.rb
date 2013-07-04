class TaggingsController < ApplicationController
  before_action :authenticate_user!

  load_resource :tag, only: :create
  load_resource :loan, only: :destroy

  before_action :set_taggable, only: :destroy

  load_resource :tagging, through: :taggable, only: :destroy

  respond_to :html, :js

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  # POST /taggings
  def create
    if params[:taggable_ids].present?
      @taggables = Loan.find(params[:taggable_ids])
      @taggables.each { |taggable| taggable.taggings.create(tag_id: @tag.id) } if @tag
    end
  end

  # DELETE /taggings/1
  def destroy
    @tagging.destroy
  end

  private

  def set_taggable
    @taggable = @loan
  end
end
