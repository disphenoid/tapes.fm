window.trackColors = {}

class Tapesfm.Views.TapedeckTape extends Backbone.View
  template: JST['tapedecks/tape']
    
  initialize: ->
    
    @model.on('change:active_tape_id', @reloadTape, this)
    @model.get("tape").on('myevent', @reRender, this)
    #@model.get("tape").get("tracks").on('add', @render, this)
    #jQuery ->
    @model.get("tape").on('change:name', @newTape, this)

    #@model.get("tape").on('change:_id', @render, this)
  reRender: ->
    window.trackColors = {}
    @render()
  newTape: ->
    if @model.get("tape").get("id") == undefined
      #console.log "!!!!!  NEW   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      #console.log @model.get("tape")
      @render()

    else
      #console.log "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      #console.log @model.get("tape")
      @render()
    
  reloadTape: ->

    window.trackColors = {}
    model = @model.get("tape")

    model.set("id": @model.get("active_tape_id"))
    model.fetch()
    #model.set("_id": @model.get("active_tape_id"))

    #@mainUploader.destroy()
    #uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
    #$('#add_track').html(uploaderView.render().el)
  render: ->
    $("#tape_scrabber").height(0)
    Tapesfm.trackm.clearTracks()
    rendertContent = @template(tapedeck: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(200)
    #Add Tracks
    
    Tapesfm.trackm.setMaxTrackLength(@model.get("tape").get("tracks"))
    @model.get("tape").get("tracks").each(@addTrack)

    if !@mainUploader

      uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
      $('#from_file').html(uploaderView.render().el)
      @mainUploader = new Uploader "#upload_field"
      #$('#from_file').hide()

    #@mainUploader.setting('buttonText',@model.get("tape").get("id"))
    @mainUploader.setTape @model.get("tape").get("_id")

    #$("#upload_field").uploadify('settings', "buttonText", @model.get("tape").get("_id"))

    this

  addTrack: (track) =>
    
    tracksView = new Tapesfm.Views.TapedeckTrack(model: track, id: "track_"+track.get("_id"))
    this.$('#tape_tracks').append(tracksView.render().el)
