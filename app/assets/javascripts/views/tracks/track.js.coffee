class Tapesfm.Views.UserTrack extends Backbone.View
  template: JST['tracks/track']
  tag: "li"
  className: "mini_track_set"
  events:
    "click .header" : "addTrack"

  initialize: ->
    # console.log @collection

  colors: (color) ->
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
  addTrack: (e) ->
    if Tapesfm.user && Tapesfm.tapedeck &&  Tapesfm.user.collaborator
      if Tapesfm.tapedeck.tapedeck.get("tape").get("track_ids").indexOf(@model.get("id")) == -1
        window.addExistingTrack @model
      else
        alert "Already in this Tape..."


  addWaveform: (data) ->


    color = @colors(@model.get("color"))

    # duration = Number($(("#track_"+data.id+"_box")).data("duration"))
    width = 300#window.tools.map(duration, 0, Tapesfm.trackm.duration, 0, Tapesfm.trackm.trackWidth)
# 
#     $(("#track_"+data.id+"_clip")).css("width",width)
#     $(("#track_"+data.id+"_base")).css("width",width)
#     $(("#track_"+data.id+"_loaded")).css("width",width)
    #width = 735

    # $("#track_"+data.id+"_clip").html("")
    #
    # console.log $(@el).find("#waveform")
    new Waveform({ width: width, interpolate: true,container: $(@el).find("#waveform").get(0), data_r: data.wavedata.right ,data_l: data.wavedata.left ,data: data.wavedata.left, innerColor: "transparent", outerColor: color })

    # $("#track_"+data.id+"_base").hide()
    # $("#track_"+data.id+"_loaded").hide()
    # $("#track_"+data.id+"_base").fadeIn(900)
    # $("#track_"+data.id+"_loaded").fadeIn(300)

    # alert(window.trackColors.length)
    # track_count = (Object.keys(window.trackColors).length)
    #$("#tape_scrabber").height(85 * track_count)


  render: ->

    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)

    $(@el).addClass("c#{@model.get("color")}")

    $(@el).find(".subline").timeago()
    $(@el).find(".title").trunacat(30)
    
    url = "http://#{Tapesfm.settings.bucket}/audio/#{@model.get("audio_id")}/#{@model.get("audio_id")}.json"
    
    jQuery.getJSON url, (data) =>
      @addWaveform data, this

    this





