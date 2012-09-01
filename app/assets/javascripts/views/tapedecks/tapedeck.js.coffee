class Tapesfm.Views.Tapedeck extends Backbone.View
  template: JST['tapedecks/tapedeck']

  initialize: ->
    @model.on('change:active_tape_id', @stop, this)

    $(document).bind('keydown', this.keyown)
    setTimeout(this.scrabberHotspot, 1)

    #window.bla = @model.on('change', @start, this)
  events:
    "click .tape_version_el" : "changeTape2"
    "click #play": "play"
    "click #pause": "pause"
    "click #resume": "resume"
    "click #stop": "stop"
    "click #add_track": "addTrack"
    #'change #change_tape' : 'changeTape'

  changeTape2: (event) ->
    console.log $(event.target).data("id")
    @model.set({"active_tape_id" : $(event.target).data("id")})

  changeTape: (event) ->
    #event.preventDefault()
    #@model.set("active_tape_id": $("#change_tape_id").val())

  keyown: (e) ->
    console.log "playstate= #{Tapesfm.trackm.tracks[0].playState
}"
    if e.keyCode == 32
      if !Tapesfm.trackm.leadTrack.playState || Tapesfm.trackm.leadTrack.paused
        $("#play").hide()
        $("#resume").hide()
        $("#pause").show()
        if Tapesfm.trackm.leadTrack.paused
          Tapesfm.trackm.resume()
        else
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
  addTrack: ->
    #alert("jupa")
    #view = new Tapesfm.Views.TrackNew()
    #$('#tapedeck_tape').prepend(view.render().el)
  resetScrabber: ->

    
  render: ->
    rendertContent = @template()
    $(@el).html(rendertContent)
    this
