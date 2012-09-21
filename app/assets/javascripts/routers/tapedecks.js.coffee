window.existing_tape = false
window.lastTape = "0"
window.lastTape_obj = null


window.onUploadComplete = (file, data) =>
  track_json = jQuery.parseJSON(data)
  
  old_uploader = $("#from_file_505a40e532b710a005000038")

  #if old_uploader && old_uploader.data('uploadifive') != undefined  && old_uploader.data('uploadifive').settings != undefined
  if track_json.replace_track_id
    Tapesfm.tapedeck.newTapeWithTrack(track_json.track,track_json.replace_track_id)
  else
    Tapesfm.tapedeck.newTape track_json.track

# window.onUploadError = (file, errorCode, errorMsg, errorString) ->
#   alert('The file ' + file.name + ' could not be uploaded: ' + errorString)
#   console.log errorCode
#   console.log errorMsg
# 
class Tapesfm.Routers.Tapedecks extends Backbone.Router
  @tapedeck
  routes:
    'tapedeck/:id' : 'tapedeck'
  initialize: ->
    #console.log "init routes"
  tapedeck: (id) ->
    #id = "testid"
    #@tapedeck = new Tapesfm.Models.Tapedeck(id:id)
    
    # Tapedeck
    window.lastTape = Tapesfm.bootstrap.tape.id
    window.td = @tapedeck = new Tapesfm.Models.Tapedeck(Tapesfm.bootstrap)
    @tapedeck.set({id:id})

    # Current set Tape
    if Tapesfm.bootstrap.tape.id
      @tapedeck.attributes.tape = new Tapesfm.Models.Tape(Tapesfm.bootstrap.tape)
      @tapedeck.attributes.tape.set({id:Tapesfm.bootstrap.tape.id})
      @tapedeck.attributes.tape.set({_id:Tapesfm.bootstrap.tape._id})
      @tapedeck.attributes.tape.attributes.tracks = new Tapesfm.Collections.Tracks(Tapesfm.bootstrap.tape.tracks)
    else
      @tapedeck.attributes.tape = new Tapesfm.Models.Tape()
      @tapedeck.attributes.tape.set({id:"0"})
      @tapedeck.attributes.tape.set({_id:"0"})
      @tapedeck.attributes.tape.set({"tapedeck_id":id})
      @tapedeck.attributes.tape.attributes.tracks = new Tapesfm.Collections.Tracks()
      

    # List of all Versions
    @tapedeck.attributes.versions = new Tapesfm.Collections.Versions(Tapesfm.bootstrap.versions)
    @tapedeck.get("versions").url = "/api/versions/"+ @tapedeck.get("id")

        
    view = new Tapesfm.Views.Tapedeck(model: @tapedeck)
    $('#container').html(view.render().el)

    headerView = new Tapesfm.Views.TapedeckHeader(model: @tapedeck)
    $('#tapedeck_header').html(headerView.render().el)
    
    #editView = new Tapesfm.Views.TapedeckEdit(model: @tapedeck)
    #$('#tapedeck_current_version').html(editView.render().el)
    versionsView = new Tapesfm.Views.TapedeckVersions(model: @tapedeck)
    $('#tapedeck_current_version').html(versionsView.render().el)

  loadTape: ->
    #Loads tape soundManager.onready
    tapeView = new Tapesfm.Views.TapedeckTape(model: @tapedeck)
    $('#tapedeck_tape').html(tapeView.render().el)

    @tapedeck.get("tape").get("tracks").each(@addTrackUploader)

  addTrackUploader: (track) ->
    if track.get("processed")

      if $("#from_file_#{track.get("id")}").hasClass("hasup")
        $("#from_file_#{track.get("id")}").uploadifive("destroy")

      $("#from_file_#{track.get("id")}").addClass("hasup")
      $("#from_file_#{track.get("id")}").uploadifive

        uploadScript      : '/upload_track'
        buttonText        : ""
        buttonCursor      : 'hand'
        auto              : true
        multi             : false
        removeCompleted   : true
        removeTimeout     : 1
        buttonClass       : "track_btn from_file"
        height            : 28
        width             : 35
        queueID           : "tape_upload"
        onQueueComplete   : ->
          $("#tape_upload").hide("slow")
        onUpload          : ->
          $("#tape_upload").show("slow")
        onAddQueueItem: ->
          data = {}
          data = Tapesfm.crsf.uploadify_script_data

          #data['tape_id'] = Tapesfm.tapedeck.tapedeck.get("tape").get("id")
          data['tapedeck_id'] = Tapesfm.tapedeck.tapedeck.get("_id")
          data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length
          data['old_track'] = $(this).data("id")

          if Tapesfm.bootstrap.active_tape_id
            data['tape_id'] = Tapesfm.tapedeck.tapedeck.get("active_tape_id")
          else
            data['tape_id'] = "0"

          unless this.data('uploadifive') == undefined || this.data('uploadifive').settings == undefined
            this.data('uploadifive').settings.formData = data
            this.data('uploadifive').settings.onUploadComplete = window.onUploadComplete
          console.log $(this).data("id")
  

  newTape: (track) ->
    #coping Tape 
    new_track = new Tapesfm.Models.Track(track)

    tape = Tapesfm.tapedeck.tapedeck.get("tape")
    tape.get("tracks").unshift new_track

    if tape.get("track_ids")
      tape.get("track_ids").push(new_track.get("id"))
    else
      tape.set({"track_ids":[]},{silent: true})
      tape.get("track_ids").push(new_track.get("id"))
    
    
    unless window.existing_tape
      tape.set({id:undefined})
      tape.set({_id:undefined},{silent: true})

    #tape.set({name:"#{tape.get("name")} copy"})
    tape.trigger("newTrack")
    tape.trigger("new")
    #modefiy values
    

  newTapeWithTrack: (track,replace_track_id) ->
    #coping Tape 
    new_track = new Tapesfm.Models.Track(track)

    tape = Tapesfm.tapedeck.tapedeck.get("tape")

    indexTo = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").indexOf(Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").get("replace_track_id"))

    tape.get("tracks").unshift new_track #,{at: indexTo}
    tape.get("tracks").remove replace_track_id, {silent: true}

    if tape.get("track_ids")

      index = tape.get("track_ids").indexOf(replace_track_id)
      tape.get("track_ids").splice(index,1)
      tape.get("track_ids").push(new_track.get("id"))

    unless window.existing_tape
      tape.set({id:undefined})
      tape.set({_id:undefined},{silent: true})

    #tape.set({name:"#{tape.get("name")} copy"})
    tape.trigger("new")
    tape.trigger("newTrack")

    
    $(".complete").each (index,item) ->
      $(item).remove()

    

    if $(".uploadifive-queue-item").length == 0
      $("#tape_upload").hide("slow")




