module Application::Filters
  extend ActiveSupport::Concern

  def set_filter
    @filter = Filter.new(start: params[:start] || flash[:start])
    flash[:start] = @filter.start
  end

  def set_user
    @filter.user_id = params[:user_id] if params[:user_id].present?
    @user = @filter.user_id ? User.find(@filter.user_id) : current_user
  end
end
