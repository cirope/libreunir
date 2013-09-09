require 'test_helper'

class BranchesUserTest < ActiveSupport::TestCase
  def setup
    @branches_user = Fabricate(:branches_user)
  end

  test 'create' do
    assert_difference ['BranchesUser.count', 'Version.count'] do
      @branches_user = BranchesUser.create(Fabricate.attributes_for(:branches_user))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'BranchesUser.count' do
        assert @branches_user.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @branches_user.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('BranchesUser.count', -1) { @branches_user.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @branches_user.attr = ''
    
    assert @branches_user.invalid?
    assert_equal 1, @branches_user.errors.size
    assert_equal [error_message_from_model(@branches_user, :attr, :blank)],
      @branches_user.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_branches_user = Fabricate(:branches_user)
    @branches_user.attr = new_branches_user.attr

    assert @branches_user.invalid?
    assert_equal 1, @branches_user.errors.size
    assert_equal [error_message_from_model(@branches_user, :attr, :taken)],
      @branches_user.errors[:attr]
  end
end
