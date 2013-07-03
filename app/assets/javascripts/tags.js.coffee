new Rule
  condition: -> $('[data-tags-new]').length
  load: ->
    @map.tag_category_check ||= ->
      $('[data-tag-category]').removeClass('selected')

      $(this).find('input[type="radio"]:first').prop('checked', true)
      $(this).addClass('selected')

    $(document).on 'click', '[data-tag-category]', @map.tag_category_check
  unload: ->
    $(document).off 'click', '[data-tag-category]', @map.tag_category_check

new Rule
  condition: -> $('.accordion').length
  load: ->
    @map.accordion_toggle ||= (e)->
      text = if e.type == 'hidden' then '' else ''
      $(this).find('.accordion-toggle .iconic').text(text)

    $(document).on 'shown hidden', '.accordion-group', @map.accordion_toggle
  unload: ->
    $(document).off 'shown hidden', '.accordion-group', @map.accordion_toggle
