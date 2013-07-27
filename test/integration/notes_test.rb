require 'test_helper'

class NotesTest < ActionDispatch::IntegrationTest
  setup do
    @user = Fabricate(:user, password: '123456', role: :normal)
  end

  test 'should create a note' do
    schedule = Fabricate(:schedule, user_id: @user.id, scheduled_at: 1.hour.from_now)
    note = Fabricate.build(:note, noteable_id: schedule.id, noteable_type: schedule.class.to_s)

    login(user: @user)

    visit schedules_path

    within "[data-schedule-id=\"#{schedule.to_param}\"]" do
      click_link ''
    end

    assert page.has_css?('#new_note')

    within '.new_note' do
      fill_in 'note_note', with: note.note
    end

    assert_difference 'Note.count' do
      find('.btn-mini').click

      assert page.has_css?('blockquote')
    end
  end
end
