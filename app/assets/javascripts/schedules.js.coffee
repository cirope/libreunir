new Rule
  condition: -> $('input[data-toggle-schedule-done]').length
  load: ->
    @map.mark_as_done_function ||= ->
      $(this).siblings('a[data-toggle-schedule-done-link]').click()

    $(document).on 'change', 'input[data-toggle-schedule-done]', @map.mark_as_done_function
  unload: ->
    $(document).off 'change', 'input[data-toggle-schedule-done]', @map.mark_as_done_function

new Rule
  condition: -> $('[data-calendar-container] [data-loading]').length
  load: ->
    $.getScript('/schedules')
