new Rule
  condition: -> $('.nav-tabs[data-default-tab]').length
  load: ->
    location.hash ||= new URLHelper().getParameter('_hash') || $('.nav-tabs[data-default-tab]').data('defaultTab')

    @map.change_location_hash_function ||= (event) ->
      location.hash = $(event.target).attr('href').substr(1)

      window.scrollTo(0, 0)

    $("a[href=\"#{location.hash}\"]").tab('show') if location.hash

    $(document).on 'shown', 'a[data-toggle="tab"]', @map.change_location_hash_function
  unload: ->
    $(document).off 'shown', 'a[data-toggle="tab"]', @map.change_location_hash_function
