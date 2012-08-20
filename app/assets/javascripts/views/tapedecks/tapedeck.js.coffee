class Tapesfm.Views.Tapedeck extends Backbone.View
  template: JST['tapedecks/tapedeck']

  initialize: ->
    @model.on('change:active_tape_id', @stop, this)

    rendertContent = @template()
    $(@el).html(rendertContent)
    $(document).bind('keydown', this.keyown)
    setTimeout(this.scrabberHotspot, 1)
     

    #window.bla = @model.on('change', @start, this)
  events:
    "click #play": "play"
    "click #pause": "pause"
    "click #resume": "resume"
    "click #stop": "stop"

  keyown: (e) ->
    console.log "playstate= #{Tapesfm.trackm.tracks[0].playState
}"
    if e.keyCode == 32
      if !Tapesfm.trackm.tracks[0].playState || Tapesfm.trackm.tracks[0].paused
        $("#play").hide()
        $("#resume").hide()
        $("#pause").show()
        Tapesfm.trackm.play()
      else
        $("#resume").show()
        $("#play").hide()
        $("#pause").hide()
        Tapesfm.trackm.pause()

  pause: ->
    this.$("#resume").show()
    this.$("#play").hide()
    this.$("#pause").hide()
    Tapesfm.trackm.pause()
  resume: ->
    this.$("#pause").show()
    this.$("#play").hide()
    this.$("#resume").hide()
    Tapesfm.trackm.resume()
  play: ->
    this.$("#play").hide()
    this.$("#resume").hide()
    this.$("#pause").show()
    Tapesfm.trackm.play()
  stop: ->
    this.$("#pause").hide()
    this.$("#resume").hide()
    this.$("#play").show()
    Tapesfm.trackm.stop()

  scrabberHotspot: ->
    $("#tape_scrabber").live "click", (e) ->
      e.stopPropagation()
      posX = $(this).offset().left
      value = e.pageX - posX

      console.log value
      Tapesfm.trackm.seek(value)
  resetScrabber: ->

  renderTapes: ->
    #@model.tape = new Tapesfm.Models.Tape({name: "mytape"}) 
    #window.bla2 = @model.get("tape").on('change', @renderTape, this)
    

    
  render: ->

    this
