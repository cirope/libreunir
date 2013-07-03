module TagsHelper
  def roots(nestedable)
    nestedable.select { |n| n.path.length == 1 }
  end

  def children(nestedable, root)
    nestedable.select { |n| n.path.length > root.path.length && n.path.include?(root.id) }
  end
end
