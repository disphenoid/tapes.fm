jQuery ->
  soundManager.setup
    url: "/assets/"
    flashVersion: "9"
    useFlashBlock: false
    onready: ->
      window.Tapesfm.trackm = new Trackm(soundManager)
      Tapesfm.tapedeck.loadTape()

window.Tapesfm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  pusher: new Pusher("c288f18f7c9bdc724b14")
  init: ->
    window.Tapesfm.tapedeck = new Tapesfm.Routers.Tapedecks()
    #new Tapesfm.Routers.Login()
    Backbone.history.start({pushState: true})

$(document).ready ->
  Tapesfm.init()
