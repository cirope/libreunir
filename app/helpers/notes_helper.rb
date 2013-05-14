module NotesHelper
  def link_to_notes(noteable, *args)
    options = args.extract_options!

    options['title'] ||= Note.model_name.human(count: 0)
    
    label = content_tag(:span, '&#xe000;'.html_safe, class: 'iconic')
    label << ' ' << content_tag(:small, "(#{noteable.notes.count})", class: 'muted')

    link_to label, *args, options
  end
end
