window.waveform = (data) =>

  waveform = new Waveform({ interpolate: true,container: document.getElementById("track_"+data.id+"_clip"), data: data.wavedata.left, innerColor: "transparent", outerColor: "#59d8ad" })
  $("#tape_scrabber").height($("#tape_scrabber").height()+85)


class Tapesfm.Views.TapedeckTrack extends Backbone.View
  template: JST['tapedecks/track']
  tagName: "li"
  className: "track"

  initialize: ->
  
  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
  addWavefrom: =>
    #myid = "track_"+@model.get("_id")
        
    #$(myid).append("shit")
    #
    #wd = jQuery.parseJSON(@model.get("wavedata"))


    # $.ajax
    #   url: url
    #   dataType: 'jsonp'
    #   jsonp: "jsonp123"
    #   success: (data) ->
    #     alert("json")

      #console.log data
      #console.log("dd")
  

    
  render: =>
    rendertContent = @template(track: @model,index: @getIndex() )
    #console.log("######### index : "+@getIndex())
    Tapesfm.trackm.addTrack {name:"track_"+@model.get("_id"),url:"http://tapesfm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.mp3"}


    
    $(@el).append(rendertContent)
    $(@el).fadeIn(500)
    #setTimeout(this.addWavefrom, 30)
    url = "http://tapesfm.s3.amazonaws.com/tracks/#{@model.get("_id")}/#{@model.get("_id")}.json"
    jQuery.getJSON url+"?callback=?"

    
    this

