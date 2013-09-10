require 'test_helper'

class BranchesUserTest < ActiveSupport::TestCase
  def setup
    @branches_user = Fabricate(:branches_user)
  end

  test 'create' do
    assert_difference 'BranchesUser.count' do
      @branches_user = BranchesUser.create(Fabricate.attributes_for(:branches_user))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'BranchesUser.count' do
        assert @branches_user.update_attributes(branch_id: 5)
      end
    end

    assert_equal 5, @branches_user.reload.branch_id
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('BranchesUser.count', -1) { @branches_user.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @branches_user.branch_id = ''
    @branches_user.user_id = nil
    
    assert @branches_user.invalid?
    assert_equal 2, @branches_user.errors.size
    assert_equal [error_message_from_model(@branches_user, :branch_id, :blank)],
      @branches_user.errors[:branch_id]
    assert_equal [error_message_from_model(@branches_user, :user_id, :blank)],
      @branches_user.errors[:user_id]
  end
end
