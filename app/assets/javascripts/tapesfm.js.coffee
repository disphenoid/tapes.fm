window.Tapesfm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new Tapesfm.Routers.Tapedecks()
    Backbone.history.start({pushState: true})

$(document).ready ->
  Tapesfm.init()
