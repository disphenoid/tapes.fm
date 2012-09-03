class Tapesfm.Views.TapedeckEdit extends Backbone.View
  template: JST['tapedecks/tape_edit']
  
  events: ->
    "click #tape_save_button" : "saveTape"
  
  initialize: ->
    #@model.get("tape").on("change:id", @render,this)
    @model.get("tape").on('change:id', @newTapeMode, this)
  
  saveTape: ->
    console.log "FKK"
    @model.get("tape").save()
  newTapeMode: ->
    
    @render()
  render: ->
    if @model.get("tape").isNew()
      $('#tape_select').hide()
      $('#tape_edit').show()
      rendertContent = @template()
      $(@el).append(rendertContent)
    
    this


