new Rule
  condition: -> $('.nav-tabs[data-remote]').length
  load: ->
    @map.remote_tab_function ||= (event) ->
      tab = $(event.target)

      if tab.data('remote-url')
        tabID = tab.attr('href')
        url = $(event.target).data('remote-url')

        $(tabID).html(
          $('<div class="alert"></div>').html($('#loading_caption').html())
        ).load(url, -> Inspector.instance().reload())

    $(document).on 'shown', '.nav-tabs[data-remote]', @map.remote_tab_function
  unload: ->
    $(document).off 'shown', '.nav-tabs[data-remote]', @map.remote_tab_function
