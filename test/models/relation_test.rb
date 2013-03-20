require 'test_helper'

class RelationTest < ActiveSupport::TestCase
  def setup
    @relation = Fabricate(:relation)
  end

  test 'create' do
    assert_difference ['Relation.count'] do
      @relation = Relation.create(Fabricate.attributes_for(:relation))
    end
  end

  test 'update' do
    new_relation = @relation.relation == Relation::TYPE.first ?
      Relation::TYPE.last : Relation::TYPE.first

    assert_difference 'Version.count' do
      assert_no_difference 'Relation.count' do
        assert @relation.update_attributes(relation: new_relation)
      end
    end

    assert_equal new_relation, @relation.reload.relation
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Relation.count', -1) { @relation.destroy }
    end
  end

  test 'validates blank attributes' do
    @relation.relation = ''

    assert @relation.invalid?
    assert_equal 1, @relation.errors.size
    assert_equal [error_message_from_model(@relation, :relation, :blank)],
      @relation.errors[:relation]
  end

  test 'validates included attributes' do
    @relation.relation = 'no_relation'

    assert @relation.invalid?
    assert_equal 1, @relation.errors.size
    assert_equal [error_message_from_model(@relation, :relation, :inclusion)],
      @relation.errors[:relation]
  end

  test 'validates length of _long_ attributes' do
    @relation.relation = 'abcde' * 52

    assert @relation.invalid?
    assert_equal 2, @relation.errors.count
    assert_equal [
      error_message_from_model(@relation, :relation, :too_long, count: 255),
      error_message_from_model(@relation, :relation, :inclusion)
    ].sort, @relation.errors[:relation].sort
  end
end
