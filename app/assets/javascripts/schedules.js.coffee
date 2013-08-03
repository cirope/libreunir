showActions = ()->
  if $('form input[type="checkbox"]:enabled:checked').length > 0
    $('.nav-actions').removeClass('hidden')
  else
    $('.nav-actions').addClass('hidden')

new Rule
  condition: -> $('a[data-mark-action]').length
  load: ->
    @map.mark_action ||= (e)->
      action = $('form[data-form-mark-as]').data('action').replace('action', $(this).data('mark-action'))
      $('form[data-form-mark-as]').attr('action', action).submit()
      e.preventDefault()

    $(document).on 'click', 'a[data-mark-action]', @map.mark_action
  unload: ->
    $(document).off 'click', 'a[data-mark-action]', @map.mark_action

new Rule
  condition: -> $('[data-schedule-form-placeholder]').length
  load: ->
    @map.show_siblings ||= (e)->
      $('[data-schedule-form-placeholder]').empty()
      $('.pagination-container').show()
      $($(this).data('show-siblings')).siblings().show()

      false

    $(document).on 'click', '[data-show-siblings]', @map.show_siblings
  unload: ->
    $(document).off 'click', '[data-show-siblings]', @map.show_siblings

new Rule
  condition: -> $('a[data-mark]').length
  load: ->
    @map.mark ||= (e)->
      $('form input[type="checkbox"]:enabled').prop('checked', $(this).data('mark'))
      showActions()
      e.preventDefault()

    $(document).on 'click', 'a[data-mark]', @map.mark
  unload: ->
    $(document).off 'click', 'a[data-mark]', @map.mark

new Rule
  condition: -> $('a[data-mark-done]').length
  load: ->
    @map.mark_done ||= (e)->
      $('form input[type="checkbox"]:enabled').prop('checked', false)
      $("form input[data-mark-done=\"#{$(this).data('mark-done')}\"]:enabled").prop('checked', true)
      showActions()
      e.preventDefault()

    $(document).on 'click', 'a[data-mark-done]', @map.mark_done
  unload: ->
    $(document).off 'click', 'a[data-mark-done]', @map.mark_done

new Rule
  condition: -> $('[data-calendar-day]').length
  load: ->
    @map.check_show_hidden ||= ->
      showActions()

    $(document).on 'change', 'input[type="checkbox"]', @map.check_show_hidden
  unload: ->
    $(document).off 'change', 'input[type="checkbox"]', @map.check_show_hidden
