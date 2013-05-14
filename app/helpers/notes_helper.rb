module NotesHelper
  def link_to_notes(noteable, *args)
    options = args.extract_options!

    options['title'] ||= Note.model_name.human(count: 0)
    
    iconic_link '&#xe000;'.html_safe, *args, options
  end
end
