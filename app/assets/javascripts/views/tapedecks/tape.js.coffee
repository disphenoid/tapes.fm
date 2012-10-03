window.trackColors = {}
window.tapeComments = {}
window.Tapesfm.commentMarkerPos = 0
window.Tapesfm.markerBlock  = false


class Tapesfm.Views.TapedeckTape extends Backbone.View
  template: JST['tapedecks/tape']
    
  events:
    "click #send_tape_button" : "createComment"
    "click .remove_track" : "removeTrack"
    "mousemove #tape_comments" : "setPosition"
    #"mouseover #tape_comments" : "overComment"
    "click #tape_comments" : "setCommand"
    "mouseout #tape_comments" : "outComment"

    "focus #comment_tape_field" : "focusField"
    "blur #comment_tape_field" : "blurField"
  
  setCommand: (e) ->
    # INFIELD SHOULD NOT BE IN HERE!
    unless window.Tapesfm.markerBlock 
      $("#comment_tape_label").inFieldLabels()

      
      $("#send_tape_button").fadeIn("slow")
      unless $("#comment_tape_field").height() > 80
        $("#comment_tape_field").animate({height: 80})
        $("#comment_tape_field").focus()

    window.Tapesfm.markerBlock = true
  createComment: (e) ->
    if $("#comment_tape_field").val() != ""

      comment = new Tapesfm.Models.Comment()
      comment.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
      comment.set({tape_id: Tapesfm.tapedeck.tapedeck.get("active_tape_id")})
      comment.set({body: $("#comment_tape_field").val()})
      comment.set({user_name: Tapesfm.user.name})
      comment.set({timestamp: window.Tapesfm.commentMarkerPos})
      comment.save()

      Tapesfm.tapedeck.tapedeck.get("comments").add(comment)

      $("#comment_tape_field").val("").focus().blur()
    #Tapesfm.tapedeck.tapedeck.get("comments").fetch()
  focusField: (e) =>
    window.Tapesfm.markerBlock = true
    # INFIELD SHOULD NOT BE IN HERE!
    $("#comment_tape_label").inFieldLabels()


    $("#send_tape_button").fadeIn("slow")
    unless $("#comment_tape_field").height() > 80
      $("#comment_tape_field").animate({height: 80})

  blurField: (e) =>

    window.Tapesfm.markerBlock = false
    if $(e.currentTarget).val() == ""
      $("#send_tape_button").fadeOut("fast")
      $(e.currentTarget).animate({height: 24})

  overComment: (e) ->
    
    #if $(e.target).attr("id") == "comment_marker"
    if !$(e.target).hasClass("mm")
      $("#comment_marker").fadeIn(300)
    console.log $(e.target).hasClass("mm")




  outComment: (e) ->
    #$("#comment_marker").hide()
    #console.log $(e.target).hasClass("mm")
    #unless window.Tapesfm.markerBlock
    if window.Tapesfm.markerBlock && $("#comment_tape_field").val() == ""
      $("#comment_tape_field").blur()
      

  setComment: (e) ->

  setPosition: (e) ->

    
    # if $(e.target).hasClass("mm")
    #   $("#comment_marker").hide()
    # else
    #   $("#comment_marker").show()

    unless window.Tapesfm.markerBlock
      cx =  Math.round(e.pageX - $(e.currentTarget).offset().left)

      if cx > 0 && cx < 700
        $("#comment_marker").css({"marginLeft": cx})

        time = Math.round(window.tools.map(cx, 0, 700, 0, Tapesfm.trackm.duration))
        window.Tapesfm.commentMarkerPos = time
        

        $("#comment_tape_label").html("Comment on #{window.tools.toTime(time)}")





  initialize: ->
    



    @model.on('change:active_tape_id', @reloadTape, this)
    #@model.on('reloadLast', @reloadLastTape, this)
    if Tapesfm.user
      @model.get("tape").on('myevent', @reRender, this)
    
    if Tapesfm.user
      @model.get("tape").get("tracks").on('remove', @reRender, this)
    #@model.get("tape").on('sync', @syncTape, this)

    #@model.get("tape").get("tracks").on('add', @render, this)
    #jQuery -> 
    if Tapesfm.user
      @model.get("tape").on('edit', @setHintEdit, this)
      @model.get("tape").on('new', @setHintNew, this)
      @model.get("tape").on('newTrack', @newTape, this)

    @model.get("tape").on('change:_id', @render, this)
    @model.get("tape").on('change:undo', @render, this)





  setHintEdit: ->
    $("#tape_save_hint_box").addClass("edit")
    $("#tape_save_button").addClass("edit")
    $("#tape_save_hint").html(Tapesfm.language.edit_hint)
  removeTrack: (track) ->
    
    #agree = confirm("Are you sure you want to delete?")

    if Tapesfm.user

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
    if Tapesfm.user
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

    if Tapesfm.user
      @model.get("tape").get("tracks").each(@addTrackUploader)

    if !@mainUploader && Tapesfm.user

      uploaderView = new Tapesfm.Views.TapedeckUploader(model: @model.get("tape"))
      $('#from_file').html(uploaderView.render().el)

      #$("#upload_field").uploadify('destroy') 
      @mainUploader = new Uploader "#upload_field"
      #$('#from_file').hide()


    if @model.get("tape").get("_id") != undefined && Tapesfm.user
      @mainUploader.setTape @model.get("tape").get("_id")


    downladsView = new Tapesfm.Views.TapedeckDownloads(collection: @model.get("tape").get("tracks"))
    $('#download_bodys').html(downladsView.render().el)
    window.tapeComments = {}
    @model.get("tape").get("comments").each(@addTapeComment)

    #$("#comment_tape_label").inFieldLabels()

    #Tapesfm.commentStrip.addComments($(@el))
    

    this

  addTapeComment: (comment) =>
    
    
    if window.tapeComments[comment.get("timestamp")] == undefined

      window.tapeComments[comment.get("timestamp")] = []
      window.tapeComments[comment.get("timestamp")].push(comment)


      time = comment.get("timestamp")

      time_in_pixel = Math.round(window.tools.map(Number(time), 0, Tapesfm.trackm.duration,0,700))

      
      this.$('#tape_comments').append("<li id=\"#{comment.get("timestamp")}\" class='tape_comment mm #{comment.get("timestamp")}' style='margin-left: #{time_in_pixel}px'> <div id='comment_hint_box' class='mm'> <div id='comment_hint_sub'> <span id='comment_hint_arrow'>&nbsp;<span> </div> </div> </li>")



      tapeCommentView = new Tapesfm.Views.TapedeckTapeComment(model: comment)

      #this.$("##{comment.get("timestamp")} ").append(tapeCommentView.render().el)


      this.$('#tape_comments').find(".#{comment.get("timestamp")} #comment_hint_sub").prepend(tapeCommentView.render().el)


    else

      window.tapeComments[comment.get("timestamp")].push(comment)
      tapeCommentView = new Tapesfm.Views.TapedeckTapeComment(model: comment)

      this.$('#tape_comments').find(".#{comment.get("timestamp")} #comment_hint_sub").prepend(tapeCommentView.render().el)
      #this.$('#tape_comments').find(".#{comment.get("timestamp")}").first().append("LAALALAL")



    
      


  addTrack: (track) =>
    
    tracksView = new Tapesfm.Views.TapedeckTrack(model: track, id: "track_"+track.get("_id"))
    this.$('#tape_tracks').append(tracksView.render().el)


