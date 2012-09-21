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
    if model.get("id") != undefined
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

  addTrackUploader: (track) =>
    if track.get("processed")


      if $("#from_file_#{track.get("id")}").hasClass("hasup")
        $("#from_file_#{track.get("id")}").uploadifive("destroy")

      $("#from_file_#{track.get("id")}").uploadifive

        uploadScript      : '/upload_track'
        buttonText        : ""
        buttonCursor      : 'hand'
        auto              : true
        multi             : false
        removeCompleted   : true
        queueSizeLimit    : 1
        removeTimeout     : 0
        
        buttonClass       : "track_btn from_file"
        height            : 28
        width             : 35
        queueID           : "tape_upload"
        onQueueComplete   : ->
          $("#tape_upload").hide()
        onUpload          : ->
          $("#tape_upload").show("slow")
        onAddQueueItem: ->
          data = {}
          data = Tapesfm.crsf.uploadify_script_data

          #data['tape_id'] = Tapesfm.tapedeck.tapedeck.get("tape").get("id")
          data['tapedeck_id'] = Tapesfm.tapedeck.tapedeck.get("_id")
          data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length
          data['old_track'] = $(this).data("id")

          if Tapesfm.tapedeck.tapedeck.get("active_tape_id")
            data['tape_id'] = Tapesfm.tapedeck.tapedeck.get("active_tape_id")
          else
            data['tape_id'] = "0"

          this.data('uploadifive').settings.formData = data
          this.data('uploadifive').settings.onUploadComplete = window.onUploadComplete

      #alert $("#from_file_#{track.get("id")}").data('uploadifive')

  render: ->
    window.trackColors = {}
    editView = new Tapesfm.Views.TapedeckEditButtons(model: @model)
    $('#tape_edit_buttons').html(editView.render().el)

    $("#tape_scrabber").height(0)
    Tapesfm.trackm.clearTracks()
    
    if @model.get("tape").get("tracks").first()
      color = @model.get("tape").get("tracks").first().get("color")
    else
      color = "none"

    rendertContent = @template(tapedeck: @model, first_color: color)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(200)
    #Add Tracks
    
    Tapesfm.trackm.setMaxTrackLength(@model.get("tape").get("tracks"))
    @model.get("tape").get("tracks").each(@addTrack)

    @model.get("tape").get("tracks").each(@addTrackUploader)

    if !@mainUploader

      uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
      $('#from_file').html(uploaderView.render().el)

      #$("#upload_field").uploadify('destroy') 
      @mainUploader = new Uploader "#upload_field"
      #$('#from_file').hide()


    if @model.get("tape").get("_id") != undefined
      @mainUploader.setTape @model.get("tape").get("_id")

    

    this

  addTrack: (track) =>
    
    tracksView = new Tapesfm.Views.TapedeckTrack(model: track, id: "track_"+track.get("_id"))
    this.$('#tape_tracks').append(tracksView.render().el)


