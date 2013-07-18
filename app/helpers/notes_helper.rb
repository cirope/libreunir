module NotesHelper
  def link_to_notes(*args)
    options = args.extract_options!

    options['title'] ||= Note.model_name.human(count: 0)
    options['class'] ||= 'iconic'

    link_to '&#xe06d;'.html_safe, *args, options
  end
end
