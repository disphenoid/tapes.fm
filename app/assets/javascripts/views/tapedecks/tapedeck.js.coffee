class Tapesfm.Views.Tapedeck extends Backbone.View
  template: JST['tapedecks/tapedeck']

  initialize: ->
    @model.on('change:active_tape_id', @stop, this)

    $(document).bind('keydown', this.keyown)
    setTimeout(this.scrabberHotspot, 1)
    

    #window.bla = @model.on('change', @start, this)
  events:
    "click #tape_save_button" : "saveTape"
    "click .tape_version_el" : "changeTape2"
    "click #play": "play"
    "click #pause": "pause"
    "click #resume": "resume"
    "click #stop": "stop"
    "click #add_track": "addTrack"
    "click #openRemix": "openRemixTape"
    "click #deccline": "decclineRemix"
    "click #remix": "remixTape"
    #'change #change_tape' : 'changeTape'

 
  remixTape: (e) ->
    remix = new Tapesfm.Models.Remix
    remix.set({tapedeck_id: @model.get("id"), tape_id: @model.get("active_tape_id")})
    $(".remix_box").html("<div class='remix_loading'> </div>")


    remix.save(
      {}
      {success: (model, response) ->
        # alert "you got a remix"
        $(".popin-overlay").removeClass("active")
        $(".remix_box").removeClass("active")

        #console.log response
        window.location = "/tapedeck/#{response.tapedeck_id}"

      })
    

  decclineRemix: (e) ->
    $(".popin-overlay").removeClass("active")
    $(".remix_box").removeClass("active")


  openRemixTape: (e) ->
    #settingView = new Tapesfm.Views.TapeSetting(model: @model)
    $(".popin-overlay").addClass("active")
    $(".remix_box").addClass("active")

    $(".popin-overlay").live "click", (e) ->
      if $(e.target).is('.popin-overlay') 
        $(".popin-overlay").removeClass("active")
        $(".remix_box").removeClass("active")
        $(".popin-overlay").die "click"

  saveTape: (e) ->

    if $("#tape_edit_field").val() != ""
      unless $(e.currentTarget).hasClass("wait")
        name = this.$("#tape_edit_field").val()
        if name
           @model.get("tape").set({"name":name}, {silent: true})
           this.$("#tape_edit_field").val("")

        @model.get("tape").save()
        window.existing_tape = false
        @model.get("tape").trigger("edit_done")
        @model.get("tape").fetch()
        $(@el).find("#tape_edit_modul").removeClass("err")
        $(@el).find("#tape_edit_label").removeClass("err")
     else
       $(@el).find("#tape_edit_modul").addClass("err")
       $(@el).find("#tape_edit_label").addClass("err")
       #alert "Enter a name for your Version."


  changeTape2: (event) ->
    #console.log $(event.currentTarget).data("id" => fals)
    @model.set({"active_tape_id" : $(event.currentTarget).data("id")})

  changeTape: (event) ->
    #event.preventDefault()
    #@model.set("active_tape_id": $("#change_tape_id").val())

  keyown: (e) ->
    console.log "playstate= #{Tapesfm.trackm.tracks[0].playState
}"
    if e.keyCode == 32 && !$("input, textarea").is(":focus")
      e.preventDefault()
      if !Tapesfm.trackm.leadTrack.playState || Tapesfm.trackm.leadTrack.paused
        $("#play").hide()
        $("#resume").hide()
        $("#pause").show()
        if Tapesfm.trackm.leadTrack.paused
          Tapesfm.trackm.resume()
        else
          Tapesfm.trackm.play()
      else
        $("#resume").show()
        $("#play").hide()
        $("#pause").hide()
        Tapesfm.trackm.pause()

  pause: ->
    this.$("#resume").show()
    this.$("#play").hide()
    this.$("#pause").hide()
    Tapesfm.trackm.pause()
  resume: ->
    this.$("#pause").show()
    this.$("#play").hide()
    this.$("#resume").hide()
    if Tapesfm.trackm.leadTrack.paused
      Tapesfm.trackm.resume()
    else
      Tapesfm.trackm.play()
  play: ->
    this.$("#play").hide()
    this.$("#resume").hide()
    this.$("#pause").show()
    if Tapesfm.trackm.leadTrack.paused
      Tapesfm.trackm.resume()
    else
      Tapesfm.trackm.play()
  
  stop: ->
    this.$("#pause").hide()
    this.$("#resume").hide()
    this.$("#play").show()
    Tapesfm.trackm.stop()

  scrabberHotspot: ->
    $(".track_hotspot").live "click", (e) ->
      e.stopPropagation()
      posX = $(this).offset().left
      value = e.pageX - posX

      console.log value
      Tapesfm.trackm.seek(value)
  addTrack: ->
    #alert("jupa")
    #view = new Tapesfm.Views.TrackNew()
    #$('#tapedeck_tape').prepend(view.render().el)
  resetScrabber: ->

  disable: ->
    if @model.get("versions").length == 0
      $(@el).find("#tapedeck_main_set").fadeTo(50,0.1)
      $(@el).find("#tapedeck_lower").fadeTo(50,0.1)
      $(@el).find("#tapedeck_tape").hide()
      $(@el).find("#download_tracks").hide()
      $(@el).find("#tapedeck_notape").show()
  enable: ->
    $(@el).find("#tapedeck_main_set").fadeTo(50,1)
    $(@el).find("#tapedeck_lower").fadeTo(50,1)
    $(@el).find("#tapedeck_tape").show()
    $(@el).find("#download_tracks").show()
    $(@el).find("#tapedeck_notape").hide() 

  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    @disable()


    this
