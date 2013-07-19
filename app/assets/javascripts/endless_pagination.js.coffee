isScrolledIntoView = (elem) ->
  docViewTop = $(window).scrollTop()
  docViewBottom = docViewTop + $(window).height()

  elemTop = $(elem).offset().top
  elemBottom = elemTop + $(elem).height()

  ((elemBottom >= docViewTop) && (elemTop <= docViewBottom) &&
    (elemBottom <= docViewBottom) && (elemTop >= docViewTop))

new Rule
  condition: -> $('*[data-endless-container]').length
  load: ->
    @map.scroll_function ||= ->
      url = $('.pagination a.next').attr('href')
      atBottom = $(window).scrollTop() > $(document).height() - $(window).height() - 150
      
      if url and (atBottom or isScrolledIntoView('.pagination-container'))
        $('.pagination-container').html(
          $('<div class="alert"></div>').html($('#loading_caption').html())
        )

        $.getScript(url, -> Inspector.instance().reload(); $(document).scroll())

    $(document).on 'scroll touchmove', @map.scroll_function
    $(document).scroll()

  unload: -> $(document).off 'scroll touchmove', @map.scroll_function
