class Tapesfm.Views.TapedeckEditButtons extends Backbone.View
  template: JST['tapedecks/tape_edit']
  
  events: ->
    "click .remove_tape_button" : "removeTape"
    "click .edit_tape_button" : "editTape"
    "click .undo_tape_button" : "undoTape"
    "click .ctrl_buttons#plus" : "plusBPM"
    "click .ctrl_buttons#minus" : "minusBPM"
    "submit form" : "changeBPM"

  initialize: ->
    #@model.get("tape").on('change:_id', @render, this)
    #@model.get("tape").on('edit', @render, this)
    if Tapesfm.user
      @model.get("tape").on('edit', @render_undo, this)
      @model.get("tape").on('new', @render_undo, this)
      @model.get("tape").on('edit_done', @render_normal, this)
  changeBPM: (e) ->

    e.preventDefault()
    
    val = $("#bpm_value").val()
    @model.get("tape").set({bpm:val})
    $("#bpm_value").val(val)
    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
    

  plusBPM: (e) ->

    val = $("#bpm_value").val()
    val = Number(val) + 1
    @model.get("tape").set({bpm:val})
    $("#bpm_value").val(val)
    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
    
  minusBPM: (e) ->
   
    val = $("#bpm_value").val()
    val = Number(val) - 1
    @model.get("tape").set({bpm:val})
    $("#bpm_value").val(val)
    if Tapesfm.user
      unless window.existing_tape
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        Tapesfm.tapedeck.tapedeck.get("tape").set({id:undefined},{silent:true})
      else
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

  editTape: (tape) ->
    window.existing_tape = true
    window.lastTape_obj = @model.get("tape").attributes
    @model.get("tape").trigger("edit")

    console.log "edit"
  removeTape: (tape) ->
    #removeID = $(tape.currentTarget).data("id")
    #alert("dd") 
    agree = confirm("if you delete this Tape it is gone!?")
    if agree
      tape_id = @model.get("tape").get("id")
      @model.get("tape").destroy()
      @model.get("versions").remove(tape_id)
      @model.get("versions").trigger("reset")
      @model.set({active_tape_id: @model.get("versions").first().get("id")})
      @model.get("tape").trigger("edit_done")

  undoTape: (tape) ->
    # undoID = $(tape.currentTarget).data("id")
    #window.lastTape = undoID

    window.existing_tape = false
    $("#tape_save_hint_box").removeClass("edit")
    $("#tape_save_button").removeClass("edit")
    $("#tape_save_hint").html(Tapesfm.language.new_hint)
    
    @model.get("tape").trigger("edit_done")

    unless @model.get("tape").get("id") == undefined
      @model.get("tape").set({undo: true},{silent: true})
      @model.get("tape").fetch()
    else
      window.trackColors = {}
      undoID = window.lastTape #@model.get("versions").first().get("id")

      @model.get("tape").set({id: undoID},{silent: true})
      @model.get("tape").set({undo: true},{silent: true})
      @model.get("tape").fetch()
      #@model.set({active_tape_id: undoID})


    console.log "fetch"
    #@model.set({tape: window.lastTape_obj})
    #@model.get("tape").trigger("newTrack")
    
    #@model.get("tape").clear({silent: true})
    #@model.get("tape").set({id:window.lastTape})
    #@model.get("tape").fetch()

    #@render_normal()

  render_normal: ->
    window.existing_tape = false
    rendertContent = @template(model:@model, edit_mode: false)
    $(@el).html(rendertContent)
    this

  render_undo: ->
    #$(@el).html("no")
    window.existing_tape = true
    rendertContent = @template(model:@model, edit_mode: true)
    $(@el).html(rendertContent)
    this
    
  render: ->
    if window.existing_tape
      @render_undo()
    else
      @render_normal()





