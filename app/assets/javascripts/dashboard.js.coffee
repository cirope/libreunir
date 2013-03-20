# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
new Rule
  condition: -> $('#c_dashboard a.popoverized').length
  load: ->
    @map.replace_function = (event, data) ->
      if $(this).data('popover') instanceof $.fn.popover.Constructor
        event.stopPropagation()
        event.preventDefault()
        $(this).popover('destroy')
        $(this).attr('data-remote', true)

    $(document).on 'click', 'a.popoverized', @map.replace_function
  unload: ->
    $(document).off 'click', 'a.popoverized', @map.replace_function