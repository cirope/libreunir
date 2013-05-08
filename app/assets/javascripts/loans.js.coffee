$(document).on 'click', '[data-remove-target]', (e) ->
  $($(this).data('removeTarget')).remove()

  if $(this).attr('href') == '#'
    e.preventDefault()
    e.stopPropagation()
