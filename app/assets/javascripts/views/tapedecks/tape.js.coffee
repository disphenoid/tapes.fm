window.trackColors = {}
window.tapeComments = {}
window.Tapesfm.commentMarkerPos = 0
window.Tapesfm.markerBlock  = false


class Tapesfm.Views.TapedeckTape extends Backbone.View
  template: JST['tapedecks/tape']
    
  events:
    "click #send_tape_button" : "createComment"
    "click .remove_track" : "removeTrack"
    "mousemove .strip_tape" : "setPosition"
    "click .strip_tape" : "setField"
    #"mouseover #tape_comments" : "overComment"
    
    "mouseleave .tape_comments_set" : "removeField"
    "mouseenter .comment" : "enterComment"
    "mouseleave .comment" : "leaveComment"

    "focus .comment_field_tape" : "focusField"
    "click #send_track_button_tape" : "createComment"
    "focus .answer_field_tape" : "focusField_replay"
    "blur .answer_field_tape" : "blurField_replay" 

    "click .send_track_button_tape_replay" : "createComment_replay"
    
  reRenderTapeComments: ->
    $(@el).find(".comment_strip_tape").html("")
    window.trackComments["tape"] = {}
    @model.get("tape").get("comments").each(@addTapeComment)

  focusField: (e) =>
    console.log "focus"
    #window.Tapesfm.markerBlock = true
    # INFIELD SHOULD NOT BE IN HERE!
    $(@el).find(".commentbox_tape #send_track_button_tape").fadeIn(200)
    $(@el).find(".commentbox_tape .comment_label_tape").inFieldLabels()


    #$("#send_tape_button").fadeIn("slow")
    unless $(@el).find(".commentbox_tape .comment_field_tape").height() > 80
      $(@el).find(".commentbox_tape .comment_field_tape").animate({height: 80},200)


  blurField: (e) =>

    if $(@el).find(".commentbox_tape .comment_field_tape").val() == ""
      $(@el).find(".commentbox_tape .comment_field_tape").animate({height: 12})
      $(@el).find(".commentbox_tape #send_track_button_tape").fadeOut("fast")

  focusField_replay: (e) =>
    $(e.currentTarget).parent().find(".send_track_button_tape_replay").fadeIn(200)
    $(e.currentTarget).parent().find(".comment_label_tape").inFieldLabels()

    unless $(e.currentTarget).height() > 80
      $(e.currentTarget).animate({height: 80},200)
  
  blurField_replay: (e) =>
    #$(@el).find(".commentbox2 .send_track_button").fadeIn(200)
    if $(e.currentTarget).val() == ""
      $(e.currentTarget).parent().find(".send_track_button_tape_replay").fadeOut(100)
      $(e.currentTarget).animate({height: 12},100)

  removeField: (e) ->
    
    $(e.currentTarget).parent().find(".commentbox_tape").fadeOut(200)
    @blurField()

  leaveComment: (e) ->
     $(@el).find(".strip_tape").show()
     #$(@el).find(".commentbox").show()
  enterComment: (e) ->
     $(@el).find(".strip_tape").hide()
     $(@el).find(".commentbox_tape").hide()

  setField: (e) ->

      window.Tapesfm.timestamp = window.Tapesfm.commentMarkerPos
    
      $(@el).find(".commentbox_tape").css({marginLeft: ((e.pageX - $(e.currentTarget).offset().left) - 110)})
      $(@el).find(".commentbox_tape").fadeIn(100)
      $(@el).find(".comment_field_tape_new").focus()
      #@focusField()

  createComment: (e) ->
    if $(@el).find("#comment_tape_field_tape_#{@model.get("tape").get("id")}").val() != ""

      comment = new Tapesfm.Models.Comment()
      comment.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
      comment.set({tape_id: Tapesfm.tapedeck.tapedeck.get("active_tape_id")})
      comment.set({tape_name: Tapesfm.tapedeck.tapedeck.get("tape").get("name")})
      comment.set({body: $(@el).find("#comment_tape_field_#{@model.get("tape").get("id")}").val()})
      comment.set({user_name: Tapesfm.user.name})
      comment.set({timestamp: window.Tapesfm.timestamp})

      comment.save()


      @model.get("tape").get("comments").add(comment)



      $(@el).find("#comment_tape_field_#{@model.get("tape").get("id")}").val("").focus().blur()
      @reRenderTapeComments()
      #@blurField()
  createComment_replay: (e) ->
    
    if $(e.currentTarget).parent().find(".answer_field").val() != ""
      #alert $(e.currentTarget).parent().find(".answer_field").data("timestamp")

      comment = new Tapesfm.Models.Comment()
      comment.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
      comment.set({tape_id: Tapesfm.tapedeck.tapedeck.get("active_tape_id")})
      comment.set({tape_name: Tapesfm.tapedeck.tapedeck.get("tape").get("name")})
      comment.set({body: $(e.currentTarget).parent().find(".answer_field_tape").val()})
      comment.set({user_name: Tapesfm.user.name})
      comment.set({timestamp: $(e.currentTarget).parent().find(".answer_field_tape").data("timestamp")})
      comment.save()

      @model.get("tape").get("comments").add(comment)

      $(e.currentTarget).parent().find(".answer_field_tape").val("").focus().blur()
      @reRenderTapeComments()
      #@model.get("comments").fetch()
      #
  setPosition: (e) ->

      cx =  Math.round(e.pageX - $(e.currentTarget).offset().left)

      if cx > 0 && cx < 775
        $(e.currentTarget).find("#marker").css({"marginLeft": cx - 13})

        time = Math.round(window.tools.map(cx, 0, 775, 0, Tapesfm.trackm.duration))
        
        window.Tapesfm.commentMarkerPos = time
        

        $(@el).find(".commentbox_tape .comment_label_tape").html("Comment on #{window.tools.toTime(time)}")
  
  setCommand: (e) ->
    # INFIELD SHOULD NOT BE IN HERE!
    unless window.Tapesfm.markerBlock 
      $("#comment_tape_label").inFieldLabels()

      
      $("#send_tape_button").fadeIn("slow")
      unless $("#comment_tape_field").height() > 80
        $("#comment_tape_field").animate({height: 80})
        $("#comment_tape_field").focus()

    window.Tapesfm.markerBlock = true




  setComment: (e) ->


  initialize: ->
    
    #@model.get("tape").get("comments").url = "/api/tape_comments/"+@model.get("tape").get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"

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
          #Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
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

    rendertContent = @template(model: @model.get("tape"), tapedeck: @model, first_color: color)
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


    #$("#comment_tape_label").inFieldLabels()

    #Tapesfm.commentStrip.addComments($(@el))
    window.trackComments["tape"] = {}
    @model.get("tape").get("comments").each(@addTapeComment)
    
    #$(@el).find(".strip_tape").hide()
    $(@el).find(".commentbox_tape").hide()

    this

  addTapeComment: (comment) =>

    if window.trackComments["tape"] == undefined
      window.trackComments["tape"] = {}
    

    if window.trackComments["tape"][comment.get("timestamp")] == undefined



      window.trackComments["tape"][comment.get("timestamp")] = []
      window.trackComments["tape"][comment.get("timestamp")].push(comment)


      time = comment.get("timestamp")

      time_in_pixel = Math.round(window.tools.map(Number(time), 0, Tapesfm.trackm.duration,0,775))

      #$(@el).find(".comment_strip").html("ddskjfls")

      if time_in_pixel <= 775
        if comment.get("user_picture_s")

          user_image = "<img class=\"image\" src=\"http://#{comment.get("user_picture_s")}\">" 
        else
          user_image = ""



        this.$('.comment_strip_tape').append("<li id=\"#{comment.get("timestamp")}\" class='comment #{comment.get("timestamp")}' style='margin-left: #{time_in_pixel}px'> 
          
        #{user_image}

        <div id=\"commentbox#{comment.get("_id")}\" class=\"commentbox2_tape\"> 
          <div class=\"body\"> 
             <ul class=\"tape_comments_box\">
             </ul>
            <div id=\"comment_box_tape\"> <div id=\"send_track_button_tape_replay\" class=\"send_track_button send_track_button_tape_replay\"> Post </div> 
             <label class=\"comment_label_tape answer_label_tape\" id=\"comment_tape_label_#{ comment.get("timestamp")}_#{ comment.get("id")}\" for=\"comment_tape_field_#{ comment.get("timestamp")}_#{comment.get("id")}\">Add a Comment</label> 
             <textarea data-timestamp=\"#{ comment.get("timestamp")}\" class=\"comment_field_tape answer_field_tape\" type=\"text\" name=\"comment_tape_field_#{ comment.get("timestamp")}_#{comment.get("id")}\" id=\"comment_tape_field_#{ comment.get("timestamp")}_#{comment.get("id")}\" value=\"\"></textarea> </div> </div>


             <div class=\"snip\"> </div>
             </div>
          
          </li>")


      #$(@el).find("#comment_tape_label_#{comment.get("timestamp")}_#{comment.get("id")}").inFieldLabels()

      #this.$("##{comment.get("timestamp")} ").append(tapeCommentView.render().el)

      tapeCommentView = new Tapesfm.Views.TapedeckTapeComment(model: comment)

      $(@el).find(".comment_strip_tape").find(".#{comment.get("timestamp")} .tape_comments_box").prepend(tapeCommentView.render().el)
      $(@el).find(".send_track_button_tape_replay").hide()


    else

      window.trackComments["tape"][comment.get("timestamp")].push(comment)
      tapeCommentView = new Tapesfm.Views.TapedeckTapeComment(model: comment)

      this.$(".comment_strip_tape").find(".#{comment.get("timestamp")} .tape_comments_box").prepend(tapeCommentView.render().el)
      
      

      #this.$('#tape_comments').find(".#{comment.get("timestamp")}").first().append("LAALALAL")


    
      


  addTrack: (track) =>
    
    tracksView = new Tapesfm.Views.TapedeckTrack(model: track, id: "track_"+track.get("_id"))
    this.$('#tape_tracks').append(tracksView.render().el)


