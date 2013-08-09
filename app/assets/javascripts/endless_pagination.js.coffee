isScrolledIntoView = (elem) ->
  docViewTop = $(window).scrollTop()
  docViewBottom = docViewTop + $(window).height()

  elemTop = $(elem).offset().top
  elemBottom = elemTop + $(elem).height()

  ((elemBottom <= docViewBottom) && (elemTop >= docViewTop))

new Rule
  condition: -> $('*[data-endless-container]').length
  load: ->
    @map.scroll_function ||= ->
      visible = $('.pagination-container').is(':visible')
      url = $('.pagination a.next').attr('href')
      atBottom = $(window).scrollTop() > $(document).height() - $(window).height() - 150

      if url and visible and (atBottom or isScrolledIntoView('.pagination-container'))
        $('.pagination-container').html(
          $('<div class="alert"></div>').html($('#loading_caption').html())
        )

        $.getScript(url, -> Inspector.instance().reload(); $(document).scroll())

    $(window).on 'scroll touchmove', @map.scroll_function
    $(document).scroll()

  unload: -> $(window).off 'scroll touchmove', @map.scroll_function
