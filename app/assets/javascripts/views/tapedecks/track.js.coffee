window.trackComments = {}
window.trackWaveforms = {}
window.colors = (color) ->
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

window.waveform = (data) =>
  #adds Waveforms
  #

  color = window.colors(window.trackColors[data.id])

  duration = Number($(("#track_"+data.id+"_box")).data("duration"))
  width = window.tools.map(duration, 0, Tapesfm.trackm.duration, 0, Tapesfm.trackm.trackWidth)

  $(("#track_"+data.id+"_clip")).css("width",width)
  $(("#track_"+data.id+"_base")).css("width",width)
  $(("#track_"+data.id+"_loaded")).css("width",width)
  #width = 735

  $("#track_"+data.id+"_clip").html("")
  window.trackWaveforms[data.id] = new Waveform({ width: width, interpolate: true,container: document.getElementById("track_"+data.id+"_clip"), data_r: data.wavedata.right ,data_l: data.wavedata.left ,data: data.wavedata.left, innerColor: "transparent", outerColor: color })

  # $("#track_"+data.id+"_base").hide()
  # $("#track_"+data.id+"_loaded").hide()
  # $("#track_"+data.id+"_base").fadeIn(900)
  # $("#track_"+data.id+"_loaded").fadeIn(300)

  # alert(window.trackColors.length)
  track_count = (Object.keys(window.trackColors).length)
  #$("#tape_scrabber").height(85 * track_count)


class Tapesfm.Views.TapedeckTrack extends Backbone.View
  template: JST['tapedecks/track']
  tagName: "li"
  pan_el: null
  vol_el: null
  uploader: null
  className: "track"

  initialize: ->
    @model.get("comments").url = "/api/track_comments/"+ @model.get("id")+"?tapedeck=#{Tapesfm.bootstrap.id}"
    @model.get("comments").on("add",@reRenderComments, this)

  events: ->
    "click .mute" : "muteTrack"
    "click .solo" : "soloTrack"
    "mousedown .pan" : "panTrack"
    "dblclick .pan" : "panTrackReset"
    "mousedown .volume" : "volumeTrack"
    "dblclick .volume" : "volumeTrackReset"

    "mousemove .strip" : "setPosition"
    "click .strip" : "setField"
    "mouseleave .track_clip_box" : "removeField"
    "mouseenter .comment" : "enterComment"
    "mouseleave .comment" : "leaveComment"
    "focus .comment_field" : "focusField"
    "focus .answer_field" : "focusField_replay"
    "blur .answer_field" : "blurField_replay"
    "click #send_track_button_new" : "createComment"
    "click .send_track_button_replay" : "createComment_replay"
    "click .color_field" : "changeColor"
    "click .name" : "editTitle"
    "click .name_save_button" : "saveTitle"
    #"blur .comment_field" : "blurField"


  editTitle: (e) ->
    if Tapesfm.user && Tapesfm.user.collaborator
      $(@el).find(".name").hide()
      $(@el).find(".name_edit_field").show().focus()
      $(@el).find(".name_save_button").show()
    


  saveTitle: (e) ->
    unless $(@el).find(".name_edit_field").val() == ""
      
      $(@el).find(".name").show()
      $(@el).find(".name_edit_field").hide()
      $(@el).find(".name_save_button").hide()
      

      $(@el).find(".name").data("full_text",$(@el).find(".name_edit_field").val())
      $(@el).find(".name").text($(@el).find(".name").data("full_text"))
      $(@el).find(".name").trunacat()


      @model.set({name: $(@el).find(".name").data("full_text")})
      @model.save(
        {}
        {success: (model, response) ->

          # alert model.get("color")

        })
     else
      alert "Please enter a Track Name!"
  changeColor: (e) ->
    color = $(e.currentTarget).data("color")

    $(@el).find(".track_info").removeClass("c1 c2 c3 c4 c5 c6 c7 c8")
    $(@el).find(".track_info").addClass("c#{color}")
    
    $(@el).find(".track_clip_box").removeClass("c1 c2 c3 c4 c5 c6 c7 c8")
    $(@el).find(".track_clip_box").addClass("c#{color}")

    trackWaveforms[@model.get("audio_id")].color window.colors(color)
    

    if @getIndex() == 1
      $("#tape_edge").removeClass("edge_1 edge_2 edge_3 edge_4 edge_5 edge_6 edge_7 edge_8")
      $("#tape_edge").addClass("edge_#{color}")

    @model.set({color: color })
    if Tapesfm.user
      @model.save(
        {}
        {success: (model, response) ->

          # alert model.get("color")

        })





      

    

  createComment_replay: (e) ->
    
    if $(e.currentTarget).parent().find(".answer_field").val() != ""
      #alert $(e.currentTarget).parent().find(".answer_field").data("timestamp")

      comment = new Tapesfm.Models.Comment()
      comment.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
      comment.set({tape_id: Tapesfm.tapedeck.tapedeck.get("active_tape_id")})
      comment.set({tape_name: Tapesfm.tapedeck.tapedeck.get("tape").get("name")})
      comment.set({track_id: @model.get("id")})
      comment.set({body: $(e.currentTarget).parent().find(".answer_field").val()})
      comment.set({user_name: Tapesfm.user.name})
      comment.set({timestamp: $(e.currentTarget).parent().find(".answer_field").data("timestamp")})
      comment.save()

      @model.get("comments").add(comment)
      Tapesfm.tapedeck.tapedeck.get("comments").add(comment)

      $(e.currentTarget).parent().find(".answer_field").val("").focus().blur()
      #@model.get("comments").fetch()

  createComment: (e) ->
    if $(@el).find("#comment_tape_field_#{@model.get("id")}").val() != ""

      comment = new Tapesfm.Models.Comment()
      comment.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
      comment.set({tape_id: Tapesfm.tapedeck.tapedeck.get("active_tape_id")})
      comment.set({tape_name: Tapesfm.tapedeck.tapedeck.get("tape").get("name")})
      comment.set({track_id: @model.get("id")})
      comment.set({body: $(@el).find("#comment_tape_field_#{@model.get("id")}").val()})
      comment.set({user_name: Tapesfm.user.name})
      comment.set({timestamp: window.Tapesfm.timestamp})

      comment.save()


      @model.get("comments").add(comment)


      Tapesfm.tapedeck.tapedeck.get("comments").add(comment)

      $(@el).find("#comment_tape_field_#{@model.get("id")}").val("").focus().blur()
      
      #@model.get("comments").fetch()
    #Tapesfm.tapedeck.tapedeck.get("comments").fetch()
  leaveComment: (e) ->
     $(@el).find(".strip").show()
     #$(@el).find(".commentbox").show()
  enterComment: (e) ->
     $(@el).find(".strip").hide()
     $(@el).find(".commentbox").hide()
  removeField: (e) ->
    
    $(e.currentTarget).parent().find(".commentbox").fadeOut(200)
    @blurField()


  setField: (e) ->

      window.Tapesfm.timestamp = window.Tapesfm.commentMarkerPos
    
      $(@el).find(".commentbox").css({marginLeft: ((e.pageX - $(e.currentTarget).offset().left) - 110)})
      $(@el).find(".commentbox").fadeIn(100)
      @focusField()
      $(@el).find(".commentbox .comment_label").focus()



  setPosition: (e) ->

      cx =  Math.round(e.pageX - $(e.currentTarget).offset().left)


      if cx > 0 && cx < 775
        $(e.currentTarget).find("#marker").css({"marginLeft": cx - 13})

        time = Math.round(window.tools.map(cx, 0, 775, 0, Tapesfm.trackm.duration))
        
        window.Tapesfm.commentMarkerPos = time
        

        $(@el).find(".commentbox .comment_label").html("Comment on #{window.tools.toTime(time)}")



  focusField_replay: (e) =>
    $(e.currentTarget).parent().find("#send_track_button_replay").fadeIn(200)
    $(e.currentTarget).parent().find(".comment_label").inFieldLabels()

    unless $(e.currentTarget).height() > 80
      $(e.currentTarget).animate({height: 80},200)
  
  blurField_replay: (e) =>
    #$(@el).find(".commentbox2 .send_track_button").fadeIn(200)
    if $(e.currentTarget).val() == ""
      $(e.currentTarget).parent().find("#send_track_button_replay").fadeOut(100)
      $(e.currentTarget).animate({height: 12},100)

  focusField: (e) =>
    #window.Tapesfm.markerBlock = true
    # INFIELD SHOULD NOT BE IN HERE!
    $(@el).find(".commentbox .send_track_button").fadeIn(200)
    $(@el).find(".commentbox .comment_label").inFieldLabels()


    #$("#send_tape_button").fadeIn("slow")
    unless $(@el).find(".commentbox .comment_field").height() > 80
      $(@el).find(".commentbox .comment_field").animate({height: 80},200)

  blurField: (e) =>

    if $(@el).find(".commentbox .comment_field").val() == ""
      $(@el).find(".commentbox .comment_field").animate({height: 12})
      $(@el).find(".commentbox .send_track_button").fadeOut("fast")

  
  volumeTrackReset: (event) ->
    @vol_el.setValue(50)
    @vol_el.setRawValue(100)

    setValue = 100

    trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
    trackSettings.set({"volume": setValue})

    Tapesfm.trackm.volumeTrack(@getIndex(),setValue)

    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  volumeTrack2: (event) ->

    start_value = event.pageY + document.body.scrollTop
    end_value = start_value
    diff = null
    @setValue = null

    #console.log "START! #{start_value}"
    #console.log "START! obj #{event.currentTarget.offsetTop + event.currentTarget.offsetHeight + document.body.scrollTop}"
    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

    $(window).bind "mouseup", (e) =>
      
      $(window).unbind "mousemove"
      $(window).unbind "mouseup"
      diff = start_value - end_value
      if diff == 0
        mousePosButtons = e.pageY + document.body.scrollTop
        staticValue = window.tools.map(mousePosButtons, event.currentTarget.offsetTop+ event.currentTarget.offsetHeight + document.body.scrollTop, event.currentTarget.offsetTop , 0,  66)
        console.log staticValue
        if staticValue > 66
          staticValue = 66
        else if staticValue < 0
          staticValue = 0
        $(event.currentTarget).find(".inner").height(staticValue)
        setValue = Math.round(window.tools.map(staticValue,0,66,0,100))
        id_name = {}
        id_name["volume_#{@getIndex()}"] = setValue
        tape = Tapesfm.tapedeck.tapedeck.get("tape")
        tape.set(id_name)
        Tapesfm.trackm.volumeTrack(@getIndex(),setValue)
        
      #coutput
      console.log "UP! #{diff/100}"

    $(window).bind "mousemove", (e) =>
      end_value = e.pageY + document.body.scrollTop
      diff = start_value - end_value
      mousePosButtons = e.pageY + document.body.scrollTop
      staticValue = window.tools.map(mousePosButtons, event.currentTarget.offsetTop+ event.currentTarget.offsetHeight + document.body.scrollTop, event.currentTarget.offsetTop , 0,  66)
      console.log staticValue
      if staticValue > 66
        staticValue = 66
      else if staticValue < 0
        staticValue = 0
      $(event.currentTarget).find(".inner").height(staticValue)
      setValue = Math.round(window.tools.map(staticValue,0,66,0,100))
      
      #id_name = {}
      
      #id_name["volume_#{@getIndex()}"] = setValue
      
      #tape = Tapesfm.tapedeck.tapedeck.get("tape")
      #tape.set(id_name)
      
      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")}).first()
      trackSettings.set({"volume": setValue})
      

      Tapesfm.trackm.volumeTrack(@getIndex(),setValue)
      

  panTrackReset: ->

    @pan_el.setValue(0)
    @pan_el.setRawValue(0)
    setValue = 0


    trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
    trackSettings.set({"pan": setValue})

    Tapesfm.trackm.panTrack(@getIndex(),setValue)

    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  volumeTrack: (event) ->

    start_value = event.pageY + document.body.scrollTop
    end_value = start_value
    diff = null
    @setValue = null

    
    console.log "DOWN!"
    $(event.currentTarget).addClass("moving")

    $(window).bind "mouseup", (e) =>
      
      $(window).unbind "mousemove"
      $(window).unbind "mouseup"

      diff = start_value - end_value
      diff = diff + @vol_el.rawValue
      #diff = diff + @vol_el.rawValue
      #if false #diff == 0

        #put here code which should be performt on a "click"

      #coutput
      @vol_el.setRawValue(diff)
      console.log "UP! #{diff/100}"
      $(event.currentTarget).removeClass("moving")

    $(window).bind "mousemove", (e) =>
      end_value = e.pageY + document.body.scrollTop
      
      diff = start_value - end_value
      diff = diff + @vol_el.rawValue
      
      console.log "diff" + diff


      mapValue = window.tools.map(diff/5000, 0, 1, 0, 100) #+ @pan_el.value

      if mapValue >= 1
        mapValue = 1
      else if mapValue < -1
        mapValue = -1

      @vol_el.setValue(mapValue)



      setValue = Math.round(window.tools.map(mapValue,-1,1,0,100))

      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
      trackSettings.set({"volume": setValue})

      Tapesfm.trackm.volumeTrack(@getIndex(),setValue)

    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  panTrack: (event) ->

    start_value = event.pageY + document.body.scrollTop
    end_value = start_value
    diff = null
    @setValue = null

    #console.log "START! #{start_value}"
    #console.log "START! obj #{event.currentTarget.offsetTop + event.currentTarget.offsetHeight + document.body.scrollTop}"
    
    console.log "DOWN!"
    $(event.currentTarget).addClass("moving")

    $(window).bind "mouseup", (e) =>
      
      $(window).unbind "mousemove"
      $(window).unbind "mouseup"
      diff = start_value - end_value
      diff = diff + @pan_el.rawValue
      #if false #diff == 0

        #put here code which should be performt on a "click"

      #coutput
      console.log "UP! #{diff/100}"
      $(event.currentTarget).removeClass("moving")
      @pan_el.setRawValue(diff)

    $(window).bind "mousemove", (e) =>
      end_value = e.pageY + document.body.scrollTop
      
      diff = start_value - end_value
      diff = diff + @pan_el.rawValue

      mapValue = window.tools.map(diff/5000, 0, 1, 0, 100) #+ @pan_el.value

      if mapValue >= 1
        mapValue = 1
      else if mapValue < -1
        mapValue = -1

      @pan_el.setValue(mapValue)



      setValue = Math.round(window.tools.map(mapValue,-1,1,-100,100))

      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
      trackSettings.set({"pan": setValue})

      Tapesfm.trackm.panTrack(@getIndex(),setValue)

    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  muteTrack: ->

    if this.$("#mute").hasClass("active")
      Tapesfm.trackm.muteTrack(@getIndex())

      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
      trackSettings.set({"mute": true})

      this.$("#mute").removeClass("active")
    else
      Tapesfm.trackm.unmuteTrack(@getIndex())

      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
      trackSettings.set({"mute": false})

      this.$("#mute").addClass("active")

    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
  soloTrack: ->
    if this.$("#solo").hasClass("active")

      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
      trackSettings.set({"solo": true})

      this.$("#solo").removeClass("active")
      Tapesfm.trackm.soloTrack(@getIndex())

    else
      trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
      trackSettings.set({"solo": false})

      this.$("#solo").addClass("active")
      Tapesfm.trackm.unsoloTrack(@getIndex())

    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1


    
  render: =>
    trackOptions = {}
    
    trackSettings = Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").where({"track_id":@model.get("id")})[0]
    
    if trackSettings #Tapesfm.tapedeck.tapedeck.get("tape").get("id") == undefined
      
   
      
      trackOptions.volume = trackSettings.get("volume")#22#Tapesfm.tapedeck.tapedeck.get("tape").get("volume_#{@getIndex()}")
      trackOptions.mute = trackSettings.get("mute")#Tapesfm.tapedeck.tapedeck.get("tape").get("mute_#{@getIndex()}")
      trackOptions.solo = trackSettings.get("solo") #Tapesfm.tapedeck.tapedeck.get("tape").get("solo_#{@getIndex()}")
      trackOptions.pan = trackSettings.get("pan") #Tapesfm.tapedeck.tapedeck.get("tape").get("pan_#{@getIndex()}")



    else


      trackOptions.volume = 100
      trackOptions.mute = false
      trackOptions.solo = true
      trackOptions.pan = 0

      new_setting = new Tapesfm.Models.TrackSetting({volume: 100, pan: 0, mute: false, solo: true, track_id: @model.get("id")})
      

      Tapesfm.tapedeck.tapedeck.get("tape").get("track_settings").add(new_setting)

    #console.log("######### index : "+@getIndex())
    if @model.get("processed")





      Tapesfm.trackm.addTrack {toptions: trackOptions,name:"track_"+@model.get("audio_id"),url:"http://#{Tapesfm.settings.bucket}.s3.amazonaws.com/audio/#{@model.get("audio_id")}/#{@model.get("audio_id")}.mp3", duration:@model.get("duration")}
    else
      track_channel = Tapesfm.pusher.subscribe(String(@model.get("audio_id")))
      track_channel.bind "track", (data) =>
        @model.set({"processed": true})
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("myevent")
        #alert("Pushing")

      Tapesfm.pusher.log = (message) ->
        if (window.console && window.console.log)
          window.console.log(message)
    
    window.trackColors[@model.get("audio_id")] = @model.get("color")
    rendertContent = @template(track: @model,index: @getIndex(), color: @model.get("color") )
    $(@el).html(rendertContent)
    #$(@el).fadeIn(500)
    #setTimeout(this.addWavefrom, 30)
    url = "http://#{Tapesfm.settings.bucket}.s3.amazonaws.com/audio/#{@model.get("audio_id")}/#{@model.get("audio_id")}.json"
    
    jQuery.getJSON url+"?callback=?"
    

    @pan_el = new window.Pan(this.$("#pan")[0],trackOptions.pan)
    @vol_el = new window.Volume(this.$("#volume")[0],trackOptions.volume)

    @vol_el.setRawValue window.tools.map(trackOptions.volume,0,100,-50,50)
    @pan_el.setRawValue window.tools.map(trackOptions.pan,-100,100,-50,50)


    #this.$(".volume .inner").height(window.tools.map(trackOptions.volume,0,100,0,66))
    #@uploader = new window.UploaderTrack(this.$("#from_file")) 
    $(@el).find(".sub").timeago()
    
    unless trackOptions.mute
      this.$("#mute").addClass("active")
    unless trackOptions.solo
      this.$("#solo").addClass("active")

    this.$(".commentbox").hide()
    this.$(".send_track_button").hide()


    window.trackComments[@model.get("id")] = {}
    if @model.get("comments").length > 0
      this.$('.comment_strip').html("")
      @model.get("comments").each(@addTapeComment)


    $(@el).find(".name").trunacat()

    this
  reRenderComments: (e) =>
    window.trackComments[@model.get("id")] = {}


    if @model.get("comments").length > 0
      this.$('.comment_strip').html("")
      @model.get("comments").each(@addTapeComment)

  addTapeComment: (comment) =>
    
    

    if window.trackComments[@model.get("id")] == undefined
      window.trackComments[@model.get("id")] = {}
    

    if window.trackComments[@model.get("id")][comment.get("timestamp")] == undefined



      window.trackComments[@model.get("id")][comment.get("timestamp")] = []
      window.trackComments[@model.get("id")][comment.get("timestamp")].push(comment)


      time = comment.get("timestamp")

      time_in_pixel = Math.round(window.tools.map(Number(time), 0, Tapesfm.trackm.duration,0,775))
      if time_in_pixel <= 775

      #$(@el).find(".comment_strip").html("ddskjfls")
        if comment.get("user_picture_s") 
          user_image = "<img class=\"image\" src=\"http://#{comment.get("user_picture_s")}\">"
        else
          user_image = ""

        this.$('.comment_strip').append("<li id=\"#{comment.get("timestamp")}\" class='comment #{comment.get("timestamp")}' style='margin-left: #{time_in_pixel}px'> 

          #{user_image}
          
        <div id=\"commentbox#{comment.get("_id")}\" class=\"commentbox2\"> 
          <div class=\"body\"> 
             <ul class=\"track_comments_box\">
             </ul>
            <div id=\"comment_box\"> <div id=\"send_track_button_replay\" class=\"send_track_button send_track_button_replay\"> Post </div> 
             <label class=\"comment_label answer_label\" id=\"comment_tape_label_#{ comment.get("timestamp")}_#{ comment.get("id")}\" for=\"comment_tape_field_#{ comment.get("timestamp")}_#{comment.get("id")}\">Add a Comment</label> 
             <textarea data-timestamp=\"#{ comment.get("timestamp")}\" class=\"comment_field answer_field\" type=\"text\" name=\"comment_tape_field_#{ comment.get("timestamp")}_#{comment.get("id")}\" id=\"comment_tape_field_#{ comment.get("timestamp")}_#{comment.get("id")}\" value=\"\"></textarea> </div> </div>


             <div class=\"snip\"> </div>
             </div>
          
          </li>")

        tapeCommentView = new Tapesfm.Views.TapedeckTapeComment(model: comment)

        #$(@el).find("#comment_tape_label_#{comment.get("timestamp")}_#{comment.get("id")}").inFieldLabels()

        #this.$("##{comment.get("timestamp")} ").append(tapeCommentView.render().el)


        $(@el).find(".comment_strip").find(".#{comment.get("timestamp")} .track_comments_box").prepend(tapeCommentView.render().el)
        $(@el).find("#send_track_button_replay").hide()



    else

      window.trackComments[@model.get("id")][comment.get("timestamp")].push(comment)
      tapeCommentView = new Tapesfm.Views.TapedeckTapeComment(model: comment)

      $(@el).find(".comment_strip").find(".#{comment.get("timestamp")} .track_comments_box").prepend(tapeCommentView.render().el)
      #this.$('#tape_comments').find(".#{comment.get("timestamp")}").first().append("LAALALAL")



