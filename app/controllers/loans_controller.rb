class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource_loans, :load_resource_tags, :set_tag, except: [:show]

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  def show
    @loan = current_user.loans.find(params[:id])
  end

  def expired
    @title = t 'view.loans.expired_title'
    @loans = @loans.expired.order('delayed_at DESC').uniq

    respond_to do |format|
      format.html # expired.html.erb
      format.js { render 'index' }
    end
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    @loans = @loans.not_expired.with_expiration.sorted_by_expiration.reverse_order.uniq

    respond_to do |format|
      format.html # close_to_expired.html.erb
      format.js { render 'index' }
    end
  end

  private
  
  def load_resource_loans
    @loans = current_user.loans.page(params[:page])
  end

  def load_resource_tags
    @tags = Tag.for_user_or_global(current_user)
  end

  def set_tag
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])

      @loans = @loans.joins(:taggings).where("#{Tagging.table_name}.tag_id = :tag_id", tag_id: @tag.id)
    end
  end
end
