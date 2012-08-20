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

  render: ->
    Tapesfm.trackm.clearTracks()
    rendertContent = @template()
    $(@el).html(rendertContent)
    $(@el).fadeIn(200)
    #Add Tracks

    @model.get("tape").get("tracks").each(@addTrack)

    this
  addTrack: (track) =>
    
    tracksView = new Tapesfm.Views.TapedeckTrack(model: track, id: "track_"+track.get("_id"))
    this.$('#tape_tracks').append(tracksView.render().el)
