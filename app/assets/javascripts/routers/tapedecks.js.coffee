window.existing_tape = false
window.edit_mode = false
window.lastTape = "0"
window.lastTape_obj = null

window.addExistingTrack = (track) => 
    
  if Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length < 8 
    if window.edit_mode
      Tapesfm.tapedeck.oldTape track #track_json.track
    else
      Tapesfm.tapedeck.newTape track #track_json.track
  else
    alert "Too many Tracks..."


window.onUploadComplete = (file, data) =>

  Tapesfm.tracks.collection.fetch()

  if Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length < 8
    track_json = jQuery.parseJSON(data)
    
    old_uploader = $("#from_file_505a40e532b710a005000038")

    #if old_uploader && old_uploader.data('uploadifive') != undefined  && old_uploader.data('uploadifive').settings != undefined
    #
    track = new Tapesfm.Models.Track(track_json.track)

    if track_json.replace_track_id
      Tapesfm.tapedeck.newTapeWithTrack(track,track_json.replace_track_id)
    else
      if window.edit_mode
        Tapesfm.tapedeck.oldTape track #track_json.track
      else
        Tapesfm.tapedeck.newTape track #track_json.track

    if $(".uploadifive-queue-item").length == $(".uploadifive-queue-item.complete").length
      $("#tape_upload").hide()
      #$("#tape_save_button").show()
      $("#tape_save_button").removeClass("wait")
      $("#tape_save_hint_sub").show()
    # alert $(".uploadifive-queue-item").length
    # alert $(".uploadifive-queue-item").length
  else
    alert "Too many Tracks..."

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
      @tapedeck.attributes.tape.attributes.tracks.each (track, index) ->
        track.attributes.comments = new Tapesfm.Collections.Comments(Tapesfm.bootstrap.tape.tracks[index].comments)
        track.get("comments").url = "/api/track_comments/"+track.get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"


      @tapedeck.attributes.tape.attributes.track_settings = new Tapesfm.Collections.TrackSettings(Tapesfm.bootstrap.tape.track_settings)
      @tapedeck.attributes.tape.attributes.comments = new Tapesfm.Collections.Comments(Tapesfm.bootstrap.tape.comments)
      @tapedeck.attributes.tape.get("comments").url = "/api/tape_comments/"+@tapedeck.get("tape").get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"
    else
      @tapedeck.attributes.tape = new Tapesfm.Models.Tape()
      @tapedeck.attributes.tape.set({id:"0"})
      @tapedeck.attributes.tape.set({_id:"0"})
      @tapedeck.attributes.tape.set({"tapedeck_id":id})
      @tapedeck.attributes.tape.attributes.tracks = new Tapesfm.Collections.Tracks()
      @tapedeck.attributes.tape.attributes.comments = new Tapesfm.Collections.Comments()
      @tapedeck.attributes.tape.attributes.track_settings = new Tapesfm.Collections.TrackSettings()
    #
    # List of all Collaborators
    @tapedeck.attributes.user = new Tapesfm.Models.User(Tapesfm.bootstrap.user)

    # List of all Versions
    @tapedeck.attributes.versions = new Tapesfm.Collections.Versions(Tapesfm.bootstrap.versions)
    @tapedeck.get("versions").url = "/api/versions/"+ @tapedeck.get("id")

    # List of all Comments
    @tapedeck.attributes.comments = new Tapesfm.Collections.Comments(Tapesfm.bootstrap.comments)
    @tapedeck.get("comments").url = "/api/comments/"+ @tapedeck.get("id")

    # Remixes
    @tapedeck.attributes.remixes = new Tapesfm.Collections.Tapedecks()
    @tapedeck.get("remixes").url = "/api/remix?tapedeck_id="+ @tapedeck.get("id")

    # List of all Collaborators
    @tapedeck.attributes.collaborators = new Tapesfm.Collections.Collaborators(Tapesfm.bootstrap.collaborators)
    @tapedeck.get("collaborators").url = "/api/collaborators/"+ @tapedeck.get("id")

    @tapedeck.attributes.invited = new Tapesfm.Collections.Invites(Tapesfm.bootstrap.invited)
    # @tapedeck.get("collaborators").url = "/api/collaborators/"+ @tapedeck.get("id")


    view = new Tapesfm.Views.Tapedeck(model: @tapedeck)
    $('#container').html(view.render().el)

    headerView = new Tapesfm.Views.TapedeckHeader(model: @tapedeck)
    $('#tapedeck_header').html(headerView.render().el)
    
    #editView = new Tapesfm.Views.TapedeckEdit(model: @tapedeck)
    #$('#tapedeck_current_version').html(editView.render().el)
    versionsView = new Tapesfm.Views.TapedeckVersions(model: @tapedeck)
    $('#tapedeck_current_version').html(versionsView.render().el)

    commentsView = new Tapesfm.Views.TapedeckComments(collection: @tapedeck.get("comments"))
    $('#new_comment').html(commentsView.render().el)

    collaboratorsView = new Tapesfm.Views.TapedeckCollaborators(collection: @tapedeck.get("collaborators"))
    $('#tapedeck_collaborators').html(collaboratorsView.render().el)

    invitesView = new Tapesfm.Views.TapedeckInvites(collection: @tapedeck.get("invited"))

    licenseView = new Tapesfm.Views.TapedeckLicense(model: @tapedeck)
    $('#tapedeck_license').html(licenseView.render().el)

    remixView = new Tapesfm.Views.TapedeckRemixes(collection: @tapedeck.get("remixes"))
    $('.tapedeck_remixes').html(remixView.render().el)


    # invitesView = new Tapesfm.Views.TapedeckInvites(collection: @tapedeck.get("collaborators"))
    # $('#tapedeck_invites').html(invitesView.render().el)



    $("label").inFieldLabels()


    $("#tape_upload").hide()
  loadTape: ->
    #Loads tape soundManager.onready
    tapeView = new Tapesfm.Views.TapedeckTape(model: @tapedeck)
    $('#tapedeck_tape').html(tapeView.render().el)

    if Tapesfm.user
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
        removeTimeout     : 0
        buttonClass       : "track_btn from_file"
        height            : 28
        width             : 35
        queueID           : "tape_upload"

        onCancel: ->

          if $(".uploadifive-queue-item").length <= 1
            $("#tape_save_button").removeClass("wait")
            $("#tape_save_hint_sub").show()
            $("#tape_upload").hide()


        onError: ->

          if $(".uploadifive-queue-item").length <= 1
            $("#tape_save_button").removeClass("wait")
            $("#tape_save_hint_sub").show()
            $("#tape_upload").hide()
        onUploadComplete : (file, data) =>
           window.onUploadComplete(file, data)
           if $(".uploadifive-queue-item").length == $(".uploadifive-queue-item.complete").length
            $("#tape_upload").hide()
            #$("#tape_save_button").show()
            $("#tape_save_button").removeClass("wait")
            $("#tape_save_hint_sub").show()
        onUpload   : ->
          $("#tape_upload").show("slow")
          if Tapesfm.user
            unless window.existing_tape
              Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
              Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
            else
              Tapesfm.tapedeck.tapedeck.get("tape").trigger("new") 
          $("#tape_save_button").addClass("wait")
          $("#tape_save_hint_sub").hide()

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
  
  oldTape: (track) ->
    new_track = track #new Tapesfm.Models.Track(track)
    new_track.attributes.comments = new Tapesfm.Collections.Comments()
    new_track.get("comments").url = "/api/track_comments/"+new_track.get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"

    tape = Tapesfm.tapedeck.tapedeck.get("tape")
    tape.get("tracks").unshift new_track

    tape.get("track_ids").push(new_track.get("id"))
  

    tape.trigger("newTrack")
    tape.trigger("edit")
    # tape.trigger("new")



  newTape: (track) ->
    #coping Tape 

    
    new_track = track 
    new_track.attributes.comments = new Tapesfm.Collections.Comments()
    new_track.get("comments").url = "/api/track_comments/"+new_track.get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"
   

    tape = Tapesfm.tapedeck.tapedeck.get("tape")
    tape.set({id: undefined, _id: undefined})
    
    tape.get("tracks").unshift new_track

    if tape.get("track_ids")
      tape.get("track_ids").push(new_track.get("id"))
    else
      tape.set({"track_ids":[]},{silent: true})
      tape.get("track_ids").push(new_track.get("id"))
    
    tape.set({user_id:Tapesfm.user._id},{silent: true})
    
    unless window.existing_tape
      tape.set({id:undefined})
      tape.set({_id:undefined},{silent: true})

    #tape.set({name:"#{tape.get("name")} copy"})
    tape.trigger("newTrack")
    tape.trigger("new")

    if Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length == 1
      $("#tapedeck_main_set").fadeTo(500,1)
      $("#tapedeck_lower").fadeTo(500,1)
      $("#tapedeck_tape").fadeIn("slow")
      $("#download_tracks").fadeIn("slow")
      $("#tapedeck_notape").hide()
    
    #modefiy values
  addTrackFromLib: (new_track) ->

  newTapeWithTrack: (track,replace_track_id) ->
    #coping Tape 
    new_track = track # new Tapesfm.Models.Track(track)
    new_track.attributes.comments = new Tapesfm.Collections.Comments()
    new_track.get("comments").url = "/api/track_comments/"+new_track.get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"

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
      tape.set({user_id:Tapesfm.user._id},{silent: true})

    #tape.set({name:"#{tape.get("name")} copy"})
    tape.trigger("new")
    tape.trigger("newTrack")

    
    # $(".complete").each (index,item) ->
    #   $(item).remove()

    

    # if $(".uploadifive-queue-item").length == 0
    #   $("#tape_upload").hide("slow")




