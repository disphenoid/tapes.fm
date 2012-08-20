class Tapesfm.Views.TapedeckTrack extends Backbone.View
  template: JST['tapedecks/track']
  tagName: "li"
  className: "track"
  #id: "track_"+ 1

  initialize: ->
  
  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
  addWavefrom: =>
    myid = "track_"+@model.get("_id")
    $("#tape_scrabber").height($("#tape_scrabber").height()+85)
    $(myid).append("shit")
    wd = jQuery.parseJSON(@model.get("wavedata"))
    @waveform = new Waveform({ interpolate: true,container: document.getElementById(myid+"_clip"), data: wd, innerColor: "transparent", outerColor: "#59d8ad" })
    
  render: ->
    rendertContent = @template(track: @model,index: @getIndex() )
    #console.log("######### index : "+@getIndex())
    Tapesfm.trackm.addTrack {name:"track_"+@model.get("_id"),url:@model.get("asset") }
    setTimeout(this.addWavefrom, 2)
    
    $(@el).append(rendertContent)
    $(@el).fadeIn(500)


    this

