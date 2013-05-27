new Rule
  condition: -> $('[data-new-tag]').length
  load: ->
    @map.tag_category_check ||= ->
      $('[data-tag-category]').removeClass('selected')

      $(this).find('input[type="radio"]:first').prop('checked', true)
      $(this).addClass('selected')

    $(document).on 'click', '[data-tag-category]', @map.tag_category_check
  unload: ->
    $(document).off 'click', '[data-tag-category]', @map.tag_category_check
