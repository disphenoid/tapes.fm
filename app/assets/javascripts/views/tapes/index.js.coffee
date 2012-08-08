class Tapesfm.Views.TapesIndex extends Backbone.View
  template: JST['tapes/index']

  initialize: ->
    
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@model.on('changed', @render, this)
    #@collection.on('add', @render, this)

  render: ->
    rendertContent = @template(tapes: @collection)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    this
