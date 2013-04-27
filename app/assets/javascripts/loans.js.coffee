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
