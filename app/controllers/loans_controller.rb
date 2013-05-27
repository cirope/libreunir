class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource_loans, except: [:create_tagging, :show]
  before_action :set_tag, except: :show

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  def show
    @loan = current_user.loans.find(params[:id])
  end

  def expired
    @title = t 'view.loans.expired_title'
    @loans = @loans.expired.order('delayed_at DESC').uniq

    load_resource_tags
    filter_loans_by_tag

    respond_to do |format|
      format.html # expired.html.erb
      format.js { render 'index' }
    end
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    @loans = @loans.not_expired.with_expiration.sorted_by_expiration.reverse_order.uniq

    load_resource_tags
    filter_loans_by_tag

    respond_to do |format|
      format.html # close_to_expired.html.erb
      format.js { render 'index' }
    end
  end

  # POST /create_tagging_loans
  def create_tagging
    if params[:loans_ids].present?
      loans = Loan.find(params[:loan_ids])

      loans.each do |loan|
        loan.taggings.create(tag_id: @tag.id) 
      end
    else
      head :ok
    end
  end

  private
  
  def load_resource_loans
    @loans = current_user.loans.page(params[:page])
  end

  def load_resource_tags
    @tags = Tag.zones_by_loans(@loans)
  end

  def set_tag
    @tag = Tag.find(params[:tag_id]) if params[:tag_id].present?
  end

  def filter_loans_by_tag
    if @tag
      if @tag.is_zone?
        @loans = @loans.joins(:taggings).where("#{Tagging.table_name}.tag_id" => @tag.id)
      else
        @loans = @tag.loans.page(params[:page])
      end
    end
  end
end
