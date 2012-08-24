class Tapesfm.Views.TapedeckTape extends Backbone.View
  template: JST['tapedecks/tape']
  
  initialize: ->
    
    @model.on('change:active_tape_id', @reloadTape, this)
    #jQuery ->
    @model.get("tape").on('change:name', @render, this)
    

  reloadTape: ->

    model = @model.get("tape")
    model.set("id": @model.get("active_tape_id"))
    model.fetch()
    $("#tape_scrabber").height(0)

    #@mainUploader.destroy()
    #uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
    #$('#add_track').html(uploaderView.render().el)
  render: ->
    Tapesfm.trackm.clearTracks()
    rendertContent = @template()
    $(@el).html(rendertContent)
    $(@el).fadeIn(200)
    #Add Tracks
    
    Tapesfm.trackm.setMaxTrackLength(@model.get("tape").get("tracks"))
    @model.get("tape").get("tracks").each(@addTrack)

    if !@mainUploader
      uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
      $('#add_track').html(uploaderView.render().el)
      @mainUploader = new Uploader "#upload_field"
    @mainUploader.setting('buttonText',@model.get("tape").get("id"))
    @mainUploader.setTape @model.get("tape").get("_id")
    #$("#upload_field").uploadify('settings', "buttonText", @model.get("tape").get("_id"))


    this

  addTrack: (track) =>
    
    tracksView = new Tapesfm.Views.TapedeckTrack(model: track, id: "track_"+track.get("_id"))
    this.$('#tape_tracks').append(tracksView.render().el)
