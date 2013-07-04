new Rule
  condition: -> $('[data-tag-id]').length
  load: ->
    @map.create_tagging ||= (e)->
      action = $('[data-form-container]').data('action').replace('tag_id', $(this).data('tag-id'))
      $('[data-form-container]').attr('action', action).submit()

      e.preventDefault()

    $(document).on 'click', '[data-tag-id]', @map.create_tagging
  unload: ->
    $(document).off 'click', '[data-tag-id]', @map.create_tagging
