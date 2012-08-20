class Tapesfm.Views.TapedeckHeader extends Backbone.View
  template: JST['tapedecks/header']
  
  events:
    'change #change_tape' : 'changeTape'
  
  initialize: ->
    
    @model.on('change:name', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)

  changeTape: (event) ->
    event.preventDefault()
    @model.set("active_tape_id":$("#change_tape_id").val())

  render: ->
    rendertContent = @template(tapedeck: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    this

