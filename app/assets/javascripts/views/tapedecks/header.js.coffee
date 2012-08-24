class Tapesfm.Views.TapedeckHeader extends Backbone.View
  template: JST['tapedecks/header']
  
  initialize: ->
    
    @model.on('change:name', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)



  render: ->
    rendertContent = @template(tapedeck: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    this

