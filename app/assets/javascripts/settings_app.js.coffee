
jQuery ->
  soundManager.setup
    url: "/assets/"
    flashVersion: "9"
    useFlashBlock: false
    onready: ->
      #window.Tapesfm.trackm = new Trackm(soundManager)
      #Tapesfm.tapedeck.loadTape()

window.Tapesfm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  pusher: new Pusher("c288f18f7c9bdc724b14")
  init: ->
    window.Tapesfm.settings = new Tapesfm.Routers.Settings()
    #new Tapesfm.Routers.Login()
    Backbone.history.start({pushState: true})

$(document).ready ->
  Tapesfm.init()
  $('.tip').tipsy( {live: true , gravity: 's', offset: 3})
  $('.tip_header').tipsy( {live: true , gravity: 'n', offset: 3})


