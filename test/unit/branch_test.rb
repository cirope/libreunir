require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  def setup
    @branch = Fabricate(:branch)
  end

  test 'create' do
    assert_difference ['Branch.count', 'Version.count'] do
      @branch = Branch.create(Fabricate.attributes_for(:branch))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Branch.count' do
        assert @branch.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @branch.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Branch.count', -1) { @branch.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @branch.attr = ''
    
    assert @branch.invalid?
    assert_equal 1, @branch.errors.size
    assert_equal [error_message_from_model(@branch, :attr, :blank)],
      @branch.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_branch = Fabricate(:branch)
    @branch.attr = new_branch.attr

    assert @branch.invalid?
    assert_equal 1, @branch.errors.size
    assert_equal [error_message_from_model(@branch, :attr, :taken)],
      @branch.errors[:attr]
  end
end
