class TaggingsController < ApplicationController
  before_action :authenticate_user!
  
  load_resource :tag, shallow: true
  load_resource :tagging, through: :tag, shallow: true

  respond_to :html, :js

  layout ->(c) { c.request.xhr? ? false : 'columns' }
  
  # POST /taggings
  def create
    @title = t('view.taggings.new_title')
  
    loans = Loan.where(id: params[:loan_ids])
    loans.each { |loan| loan.taggings.create(tag_id: @tag.id) } if @tag

    respond_to do |format|
      format.js { render 'reload' }
    end
  end

  # DELETE /taggings/1
  def destroy
    @tagging.destroy

    respond_to do |format|
      format.js { render 'reload' }
    end
  end
end
