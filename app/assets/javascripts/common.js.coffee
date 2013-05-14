new Rule
  load: ->
    # For browsers with no autofocus support
    $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
    $('[data-show-tooltip]').tooltip()

    timers = @map.timers = []
    
    $('.alert[data-close-after]').each (i, a)->
      timers.push setTimeout((-> $(a).alert('close')), $(a).data('close-after'))

  unload: -> clearTimeout timer for i, timer of @map.timers

jQuery ($) ->
  $(document).on 'click', 'a.submit', -> $('form').submit(); false
  
  $(document).ajaxStart ->
    $('#loading_caption').stop(true, true).fadeIn(100)
  .ajaxStop ->
    $('#loading_caption').stop(true, true).fadeOut(100)
  
  $(document).on 'submit', 'form', ->
    $(this).find('input[type="submit"], input[name="utf8"]').attr 'disabled', true
    $(this).find('a.submit').removeClass('submit').addClass('disabled')
    $(this).find('.dropdown-toggle').addClass('disabled')
    
    if location.hash
      hiddenHash = $('<input type="hidden" name="_hash" />').val(location.hash.substr(1))

      $(this).append hiddenHash

  Inspector.instance().load()

$(document).on 'click', '[data-remove-target]', (e) ->                                                                                                
  $($(this).data('removeTarget')).remove()
  
  if $(this).attr('href') == '#'
    e.preventDefault()
    e.stopPropagation()

$(document).on 'click', '[data-empty-target]', (e) ->                                                                                                
  $($(this).data('emptyTarget')).empty()
  
  if $(this).attr('href') == '#'
    e.preventDefault()
    e.stopPropagation()
