new Rule
  condition: -> $('[data-tag-id]').length
  load: ->
    @map.create_tagging ||= (event)->
      $('#tag_id').val($(this).data('tag-id'))
      $('#tag_id').closest('form').submit()

    $(document).on 'click', '[data-tag-id]', @map.create_tagging
  unload: ->
    $(document).off 'click', '[data-tag-id]', @map.create_tagging
