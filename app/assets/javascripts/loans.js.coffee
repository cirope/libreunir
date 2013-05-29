new Rule
  condition: -> $('[data-tag-id]').length
  load: ->
    @map.create_tagging ||= ->
      form = $('[data-form-container]').find('form')
      action = form.attr('action').replace('tag_id', $(this).data('tag-id'))
      form.attr('action', action).submit()

    $(document).on 'click', '[data-tag-id]', @map.create_tagging
  unload: ->
    $(document).off 'click', '[data-tag-id]', @map.create_tagging
