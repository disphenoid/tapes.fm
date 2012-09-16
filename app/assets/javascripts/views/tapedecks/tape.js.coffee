window.trackColors = {}


class Tapesfm.Views.TapedeckTape extends Backbone.View
  template: JST['tapedecks/tape']
    
  events:
    "click .remove_track" : "removeTrack"
    

  initialize: ->
    
    @model.on('change:active_tape_id', @reloadTape, this)
    #@model.on('reloadLast', @reloadLastTape, this)
    @model.get("tape").on('myevent', @reRender, this)
    
    @model.get("tape").get("tracks").on('remove', @reRender, this)
    #@model.get("tape").on('sync', @syncTape, this)

    #@model.get("tape").get("tracks").on('add', @render, this)
    #jQuery ->
    
    @model.get("tape").on('newTrack', @newTape, this)

    @model.get("tape").on('change:_id', @render, this)
    @model.get("tape").on('change:undo', @render, this)


  removeTrack: (track) ->
    
    #agree = confirm("Are you sure you want to delete?")

    if true#agree

      removeID = $(track.currentTarget).data("id")
      @model.get("tape").get("tracks").remove removeID
      
      indexRemove = @model.get("tape").get("track_ids").indexOf(removeID)
      @model.get("tape").get("track_ids").splice(indexRemove,1)
      #alert(indexRemove)

      unless window.existing_tape
        @model.get("tape").trigger("new")
        @model.get("tape").set({id:undefined},{silent:true})
        @model.get("tape").set({_id:undefined},{silent:true})
      
      @reRender()
    else


    #@model.get("tape").save()
    #@model.get("tape").fetch()


      #@reRender()


    #@reRender()

  reRender: ->
    window.trackColors = {}
    @render()
  newTape: ->
    @model.set({active_tape_id: @model.get("tape").get("id")})

    if @model.get("tape").get("id") == undefined
      @render()

    else
      @render()
  reloadTape: ->
    window.trackColors = {}
    unless @model.get("tape").isNew()
      window.lastTape = @model.get("active_tape_id")

    window.trackColors = {}
    model = @model.get("tape")

    model.set("id": @model.get("active_tape_id"))
    model.fetch()

  reloadLastTape: ->
    window.trackColors = {}
    tape = @model.get("tape")

    tape.set("id": window.lastTape)
    tape.fetch()
    #model.set("_id": @model.get("active_tape_id"))

    #@mainUploader.destroy()
    #uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
    #$('#add_track').html(uploaderView.render().el)
  syncTape: ->
    alert "sync"
  render: ->
    window.trackColors = {}
    editView = new Tapesfm.Views.TapedeckEditButtons(model: @model)
    $('#tape_edit_buttons').html(editView.render().el)

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
