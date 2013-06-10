new Rule
  condition: -> $('[data-form-order-by]').length
  load: ->
    @map.order_by_submit ||= ->
      $(this).closest('form').submit()

    $(document).on 'change', '#order_by', @map.order_by_submit
  unload: ->
    $(document).off 'change', '#order_by', @map.order_by_submit
