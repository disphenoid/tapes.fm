window.waveform = (data) =>
  #adds Waveforms
  duration = Number($(("#track_"+data.id+"_box")).data("duration"))
  width = window.tools.map(duration, 0, Tapesfm.trackm.duration, 0, Tapesfm.trackm.trackWidth)

  $(("#track_"+data.id+"_clip")).css("width",width)
  $(("#track_"+data.id+"_base")).css("width",width)
  $(("#track_"+data.id+"_loaded")).css("width",width)
  #width = 735

  waveform = new Waveform({ width: width, interpolate: true,container: document.getElementById("track_"+data.id+"_clip"), data: data.wavedata.left, innerColor: "transparent", outerColor: "#59d8ad" })
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
    rendertContent = @template(track: @model,index: @getIndex() )
    #console.log("######### index : "+@getIndex())
    Tapesfm.trackm.addTrack {name:"track_"+@model.get("_id"),url:"http://tapesfm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.mp3", duration:@model.get("duration")}


    
    $(@el).append(rendertContent)
    $(@el).fadeIn(500)
    #setTimeout(this.addWavefrom, 30)
    url = "http://tapesfm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.json"
    jQuery.getJSON url+"?callback=?"

    
    this

