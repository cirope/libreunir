class @URLHelper
  getParameter: (name) ->
    regex = new RegExp("[?|&]#{name}=([^&;]+?)(&|#|;|$)")

    decodeURIComponent regex.exec(location.search)[1] if regex.exec(location.search)
