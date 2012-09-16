class Tapesfm.Views.TapedeckEditButtons extends Backbone.View
  template: JST['tapedecks/tape_edit']
  
  events: ->
    "click .remove_tape_button" : "removeTape"
    "click .edit_tape_button" : "editTape"
    "click .undo_tape_button" : "undoTape"

  initialize: ->
    #@model.get("tape").on('change:_id', @render, this)
    #@model.get("tape").on('edit', @render, this)
    @model.get("tape").on('edit', @render_undo, this)
    @model.get("tape").on('new', @render_undo, this)
    @model.get("tape").on('edit_done', @render, this)
    
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

  undoTape: (tape) ->
    # undoID = $(tape.currentTarget).data("id")
    #window.lastTape = undoID

    window.existing_tape = false
    
    @model.get("tape").trigger("edit_done")

    unless @model.get("tape").get("id") == undefined
      @model.get("tape").set({undo: true},{silent: true})
      @model.get("tape").fetch()
    else
      window.trackColors = {}
      undoID = window.lastTape#@model.get("versions").first().get("id")

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

    @render_normal()

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





