class Tapesfm.Views.TapedeckEdit extends Backbone.View
  template: JST['tapedecks/tape_edit']
  
  events: ->
    "click #tape_save_button" : "saveTape"
  
  initialize: ->
    #@model.get("tape").on("change:id", @render,this)
    if Tapesfm.user
      @model.get("tape").on('change:id', @newTapeMode, this)
  
  saveTape: ->
    if Tapesfm.user
      # val = $(".bpm_value").val()
      # @model.get("tape").set({bpm:val})

      @model.get("tape").trigger("edit_done")

     
      @model.get("tape").save()
      $("#tape_save_hint_box").removeClass("edit")
      $("#tape_save_button").removeClass("edit")
      $("#tape_save_hint").html(Tapesfm.language.new_hint)
    # @model.get("tape").fetch()
    # @model.set({active_tape_id: window.lastTape})
    # @model.get("tape").set({id: window.lastTape})
    
    # Tapesfm.tapedeck.loadTape()

  newTapeMode: ->
    @render()
  render: ->
    if @model.get("tape").isNew()
      rendertContent = @template()
      $(@el).append(rendertContent)
      $(@el).find('.bpm_value').numeric()
    
    this


