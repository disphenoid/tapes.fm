window.colors = (color) ->
  switch color
    when 1
      "#ff7357"
    when 2
      "#e6e15f"
    when 3
      "#59d8ad"
    when 4
      "#36bddd"
    when 5
      "#e96d8e"
    when 6
      "#ffc257"
    when 7
      "#d5c4ab"
    when 8
      "#539994"
    else
      "#000"

window.waveform = (data) =>
  #adds Waveforms
  #

  color = window.colors(window.trackColors[data.id])

  duration = Number($(("#track_"+data.id+"_box")).data("duration"))
  width = window.tools.map(duration, 0, Tapesfm.trackm.duration, 0, Tapesfm.trackm.trackWidth)

  $(("#track_"+data.id+"_clip")).css("width",width)
  $(("#track_"+data.id+"_base")).css("width",width)
  $(("#track_"+data.id+"_loaded")).css("width",width)
  #width = 735

  $("#track_"+data.id+"_clip").html("")
  waveform = new Waveform({ width: width, interpolate: true,container: document.getElementById("track_"+data.id+"_clip"), data: data.wavedata.left, innerColor: "transparent", outerColor: color })

  # alert(window.trackColors.length)
  track_count = (Object.keys(window.trackColors).length)
  $("#tape_scrabber").height(85 * track_count)


class Tapesfm.Views.TapedeckTrack extends Backbone.View
  template: JST['tapedecks/track']
  tagName: "li"
  className: "track"

  initialize: ->
  events: ->
    "click .mute" : "muteTrack"
    "click .solo" : "soloTrack"
  
  muteTrack: ->

    if this.$("#mute").hasClass("active")
      Tapesfm.trackm.muteTrack(@getIndex())
      id_name = {}
      id_name["mute_#{@getIndex()}"] = true

      tape = Tapesfm.tapedeck.tapedeck.get("tape")
      tape.set(id_name)
      this.$("#mute").removeClass("active")
    else
      Tapesfm.trackm.unmuteTrack(@getIndex())
      id_name = {}
      id_name["mute_#{@getIndex()}"] = false

      tape = Tapesfm.tapedeck.tapedeck.get("tape")
      tape.set(id_name)

      this.$("#mute").addClass("active")

    Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
  soloTrack: ->
    if this.$("#solo").hasClass("active")
      id_name = {}
      id_name["solo_#{@getIndex()}"] = true
      tape = Tapesfm.tapedeck.tapedeck.get("tape")
      tape.set(id_name)
      this.$("#solo").removeClass("active")
      Tapesfm.trackm.soloTrack(@getIndex())

    else
      id_name = {}
      id_name["solo_#{@getIndex()}"] = false

      tape = Tapesfm.tapedeck.tapedeck.get("tape")
      tape.set(id_name)

      this.$("#solo").addClass("active")
      Tapesfm.trackm.unsoloTrack(@getIndex())

    Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
    
  render: =>
    trackOptions = {}
    if Tapesfm.tapedeck.tapedeck.get("tape").get("id") == undefined
      trackOptions.volume = Tapesfm.tapedeck.tapedeck.get("tape").get("volume_#{@getIndex()}")
      trackOptions.mute = Tapesfm.tapedeck.tapedeck.get("tape").get("mute_#{@getIndex()}")
      trackOptions.solo = Tapesfm.tapedeck.tapedeck.get("tape").get("solo_#{@getIndex()}")
      trackOptions.pan = Tapesfm.tapedeck.tapedeck.get("tape").get("pan_#{@getIndex()}")
     else
      trackOptions.volume = 100
      trackOptions.mute = false
      trackOptions.solo = false
      trackOptions.pan = 0
    #console.log("######### index : "+@getIndex())
    if @model.get("processed")





      Tapesfm.trackm.addTrack {toptions: trackOptions,name:"track_"+@model.get("_id"),url:"http://tapes.fm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.mp3", duration:@model.get("duration")}
    else
      track_channel = Tapesfm.pusher.subscribe(String(@model.get("id")))
      track_channel.bind "track", (data) =>
        @model.set({"processed": true})
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("myevent")
        #alert("Pushing")

      Tapesfm.pusher.log = (message) ->
        if (window.console && window.console.log)
          window.console.log(message)
    
    window.trackColors[@model.get("id")] = @model.get("color")
    rendertContent = @template(track: @model,index: @getIndex(), color: @model.get("color") )
    $(@el).html(rendertContent)
    #$(@el).fadeIn(500)
    #setTimeout(this.addWavefrom, 30)
    url = "http://tapes.fm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.json"
    jQuery.getJSON url+"?callback=?"
    
    unless trackOptions.mute
      this.$("#mute").addClass("active")

    this

