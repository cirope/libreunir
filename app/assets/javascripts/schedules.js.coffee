showActions = ()->
  if $('form input[type="checkbox"]:enabled:checked').length > 0
    $('.navtags > li.active').siblings().removeClass()
  else
    $('.navtags > li.active').siblings().addClass('hidden')

new Rule
  condition: -> $('[data-calendar-container] [data-loading]').length
  load: ->
    $.getScript('/schedules')

new Rule
  condition: -> $('a[data-mark-as]').length
  load: ->
    @map.form_mark_as ||= (e)->
      action = $('form[data-form-mark-as]').data('action').replace('action', $(this).data('action'))
      $('form[data-form-mark-as]').attr('action', action).submit()
      e.preventDefault()

    $(document).on 'click', 'a[data-mark-as]', @map.form_mark_as
  unload: ->
    $(document).off 'click', 'a[data-mark-as]', @map.form_mark_as

new Rule
  condition: -> $('[data-schedule-form-placeholder]').length
  load: ->
    @map.show_siblings ||= (e)->
      $('[data-schedule-form-placeholder]').empty()
      $('.pagination-container').show()
      $($(this).data('show-siblings')).show()

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
  condition: -> $('form input[type="checkbox"]:enabled').length
  load: ->
    @map.check_show_hidden ||= ->
      showActions()

    $(document).on 'change', 'input[type="checkbox"]', @map.check_show_hidden
  unload: ->
    $(document).off 'change', 'input[type="checkbox"]', @map.check_show_hidden
