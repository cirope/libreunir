new Rule
  condition: -> $('input[data-toggle-schedule-done]').length
  load: ->
    @map.mark_as_done_function ||= ->
      console.log 'click'
      $(this).siblings('a[data-toggle-schedule-done-link]').click()

    console.log 'loaded'

    $(document).on 'change', 'input[data-toggle-schedule-done]', @map.mark_as_done_function
  unload: ->
    $(document).off 'change', 'input[data-toggle-schedule-done]', @map.mark_as_done_function
