window.Tapesfm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new Tapesfm.Routers.Tapes()
    Backbone.history.start({pushState: true})

$(document).ready ->
  Tapesfm.init()
