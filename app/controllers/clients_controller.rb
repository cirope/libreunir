class ClientsController < ApplicationController
  before_action :authenticate_user!
  
  check_authorization
  load_and_authorize_resource through: :current_user

  layout ->(c) { c.request.xhr? ? false : 'application' }

  respond_to :html, :js

  # GET /clients
  # GET /clients.json
  def index
    @title = t('view.clients.index_title')
    @searchable = true
    @clients = @clients.filtered_list(params[:q]).page(params[:page])

    respond_with @clients
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @title = t('view.clients.show_title')

    respond_with @client
  end
end
