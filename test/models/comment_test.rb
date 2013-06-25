require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = Fabricate(:comment)
  end

  test 'create' do
    assert_difference 'Comment.count' do
      @comment = Comment.create(Fabricate.attributes_for(:comment))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Comment.count' do
        assert @comment.update_attributes(comment: 'Updated')
      end
    end

    assert_equal 'Updated', @comment.reload.comment
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Comment.count', -1) { @comment.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @comment.comment = ''
    @comment.user_id = nil
    @comment.loan_id = nil
    
    assert @comment.invalid?
    assert_equal 3, @comment.errors.size
    assert_equal [error_message_from_model(@comment, :comment, :blank)],
      @comment.errors[:comment]
    assert_equal [error_message_from_model(@comment, :user_id, :blank)],
      @comment.errors[:user_id]
    assert_equal [error_message_from_model(@comment, :loan_id, :blank)],
      @comment.errors[:loan_id]
  end
end
