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

  # $("#track_"+data.id+"_base").hide()
  # $("#track_"+data.id+"_loaded").hide()
  # $("#track_"+data.id+"_base").fadeIn(900)
  # $("#track_"+data.id+"_loaded").fadeIn(300)

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
    "mousedown .pan" : "panTrack"
    "mousedown .vol" : "panTrack"
  
  panTrack: (event) ->

    start_value = event.pageY + document.body.scrollTop
    end_value = start_value
    diff = null
    @setValue = null

    #console.log "START! #{start_value}"
    #console.log "START! obj #{event.currentTarget.offsetTop + event.currentTarget.offsetHeight + document.body.scrollTop}"
    Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

    $(window).bind "mouseup", (e) =>
      
      $(window).unbind "mousemove"
      $(window).unbind "mouseup"
      diff = start_value - end_value
      if diff == 0
        mousePosButtons = e.pageY + document.body.scrollTop
        staticValue = window.tools.map(mousePosButtons, event.currentTarget.offsetTop+ event.currentTarget.offsetHeight + document.body.scrollTop, event.currentTarget.offsetTop , 0,  66)
        console.log staticValue
        if staticValue > 66
          staticValue = 66
        else if staticValue < 0
          staticValue = 0
        $(event.currentTarget).find(".inner").height(staticValue)
        setValue = Math.round(window.tools.map(staticValue,0,66,0,100))
        id_name = {}
        id_name["volume_#{@getIndex()}"] = setValue
        tape = Tapesfm.tapedeck.tapedeck.get("tape")
        tape.set(id_name)
        Tapesfm.trackm.volumeTrack(@getIndex(),setValue)
        
      #coutput
      console.log "UP! #{diff/100}"

    $(window).bind "mousemove", (e) =>
      end_value = e.pageY + document.body.scrollTop
      diff = start_value - end_value
      mapValue = window.tools.map(diff/400, 0, 1, 0,  66)
      currentHeight = $(event.currentTarget).find(".inner").height()

      theVal = currentHeight + Math.round(mapValue)
      if theVal > 66
        theVal = 66
      else if theVal < 0
        theVal = 0

      $(event.currentTarget).find(".inner").height(theVal)
      setValue = Math.round(window.tools.map(theVal,0,66,0,100))

      id_name = {}
      id_name["volume_#{@getIndex()}"] = setValue
      tape = Tapesfm.tapedeck.tapedeck.get("tape")
      tape.set(id_name)
      Tapesfm.trackm.volumeTrack(@getIndex(),setValue)


    console.log "SETVALUE = #{@setValue}"



    

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
    unless Tapesfm.tapedeck.tapedeck.get("tape").get("id") == undefined
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
    

    this.$(".volume .inner").height(window.tools.map(trackOptions.volume,0,100,0,66))

    unless trackOptions.mute
      this.$("#mute").addClass("active")

    this

