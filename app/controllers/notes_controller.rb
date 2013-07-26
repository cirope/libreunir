class NotesController < ApplicationController
  before_action :authenticate_user!
  
  check_authorization
  load_resource :schedule, shallow: true

  before_action :set_noteable

  load_and_authorize_resource through: :noteable

  layout ->(c) { c.request.xhr? ? false : 'application' }

  respond_to :html, :js

  # GET /notes
  def index
    @title = t('view.notes.index_title')
  end

  # POST /notes
  def create
    @title = t('view.notes.new_title')

    if @note.save
      respond_to do |format|
        format.js { redirect_to schedules_url, format: :js }
      end
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:note)
  end

  def set_noteable
    @noteable = @schedule
  end
end
