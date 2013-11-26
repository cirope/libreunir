require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  def setup
    @branch = Fabricate(:branch)
  end

  test 'create' do
    assert_difference 'Branch.count' do
      @branch = Branch.create(Fabricate.attributes_for(:branch))
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Branch.count' do
        assert @branch.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @branch.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Branch.count', -1) { @branch.destroy }
    end
  end

  test 'validates blank attributes' do
    @branch.name = ''
    @branch.branch_id = nil

    assert @branch.invalid?
    assert_equal 2, @branch.errors.size
    assert_equal [error_message_from_model(@branch, :name, :blank)],
      @branch.errors[:name]
    assert_equal [error_message_from_model(@branch, :branch_id, :blank)],
      @branch.errors[:branch_id]
  end

  test 'validates unique attributes' do
    new_branch = Fabricate(:branch)
    @branch.name = new_branch.name

    assert @branch.invalid?
    assert_equal 1, @branch.errors.size
    assert_equal [error_message_from_model(@branch, :name, :taken)],
      @branch.errors[:name]
  end
end
