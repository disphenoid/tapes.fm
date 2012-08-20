class Tapesfm.Views.TapesIndex extends Backbone.View
  template: JST['tapes/index']

  initialize: ->
    
    #@model.on('change', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)
    rendertContent = @template(tapes: @model)
    $(@el).html(rendertContent)

  render: ->
    #$(@el).fadeIn(2000)
    this
