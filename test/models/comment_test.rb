require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = Fabricate(:comment)
  end

  test 'create' do
    assert_difference ['Comment.count', 'Version.count'] do
      @comment = Comment.create(Fabricate.attributes_for(:comment))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Comment.count' do
        assert @comment.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @comment.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Comment.count', -1) { @comment.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @comment.attr = ''
    
    assert @comment.invalid?
    assert_equal 1, @comment.errors.size
    assert_equal [error_message_from_model(@comment, :attr, :blank)],
      @comment.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_comment = Fabricate(:comment)
    @comment.attr = new_comment.attr

    assert @comment.invalid?
    assert_equal 1, @comment.errors.size
    assert_equal [error_message_from_model(@comment, :attr, :taken)],
      @comment.errors[:attr]
  end
end
