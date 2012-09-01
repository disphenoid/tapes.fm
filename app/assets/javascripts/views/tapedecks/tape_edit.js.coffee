class Tapesfm.Views.TapedeckEdit extends Backbone.View
  template: JST['tapedecks/tape_edit']
  
  events: ->
    "click #save_button" : "saveTape"
  
  initialize: ->
    #@model.get("tape").on("change:id", @render,this)
    @model.get("tape").on('change:id', @newTapeMode, this)
  
  saveTape: ->
    @model.get("tape").save()
  newTapeMode: ->
    
    @render()
  render: ->
    if @model.get("tape").isNew()
      $('#tapedeck_versions').hide()
      $('#edit_mode').show()
      rendertContent = @template()
      $(@el).append(rendertContent)
    
    this


