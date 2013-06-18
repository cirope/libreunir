new Rule
  condition: -> $('[data-tag-id]').length
  load: ->
    @map.create_tagging ||= ->
      action = $('[data-form-container]').attr('action').replace('tag_id', $(this).data('tag-id'))
      $('[data-form-container]').attr('action', action).submit()

    $(document).on 'click', '[data-tag-id]', @map.create_tagging
  unload: ->
    $(document).off 'click', '[data-tag-id]', @map.create_tagging
