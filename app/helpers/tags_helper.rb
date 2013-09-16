module TagsHelper
  def roots(nestedable)
    nestedable.select { |n| n.root? }
  end

  def children(nestedable, root)
    nestedable.select { |n| n.ancestry.to_i == root.id }
  end

  def truncate_tag_name(tag, length = nil)
    truncate(tag.name, length: (length || 20))
  end

  def link_to_tag(tag, *args)
    options = args.extract_options!

    options['title'] ||= tag.name
    options['data-show-tooltip'] ||= true
    url = options['data-url'] || [action_name, tag, controller_name]

    link_to truncate_tag_name(tag), url, options
  end
end
