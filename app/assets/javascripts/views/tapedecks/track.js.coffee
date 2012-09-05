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

  waveform = new Waveform({ width: width, interpolate: true,container: document.getElementById("track_"+data.id+"_clip"), data: data.wavedata.left, innerColor: "transparent", outerColor: color })
  $("#tape_scrabber").height($("#tape_scrabber").height()+85)


class Tapesfm.Views.TapedeckTrack extends Backbone.View
  template: JST['tapedecks/track']
  tagName: "li"
  className: "track"

  initialize: ->
  
  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
    
  render: =>

    rendertContent = @template(track: @model,index: @getIndex(), color: @model.get("color") )
    #console.log("######### index : "+@getIndex())
    Tapesfm.trackm.addTrack {name:"track_"+@model.get("_id"),url:"http://tapesfm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.mp3", duration:@model.get("duration")}


    
    $(@el).append(rendertContent)

    $(@el).fadeIn(500)
    #setTimeout(this.addWavefrom, 30)
    url = "http://tapesfm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.json"
    jQuery.getJSON url+"?callback=?"

    this

