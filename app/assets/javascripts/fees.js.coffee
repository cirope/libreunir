$(document).on 'click', '[data-remove-target]', ->
  $($(this).data('removeTarget')).remove()
