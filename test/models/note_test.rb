require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @note = Fabricate(:note)
  end

  test 'create' do
    assert_difference 'Note.count' do
      @note = Note.create(Fabricate.attributes_for(:note))
    end 
  end
    
  test 'validates blank attributes' do
    @note.note = ''

    assert @note.invalid?
    assert_equal 1, @note.errors.size
    assert_equal [error_message_from_model(@note, :note, :blank)],
      @note.errors[:note]
  end
end
