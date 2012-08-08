class Tapesfm.Views.TapesTracks extends Backbone.View
  template: JST['tapes/tracks']

  initialize: ->
    
    #@collection.on('reset', @render, this)
    
    @model.on('change', @render, this)
    #@collection.on('changed:name', @render, this)
    #@model.on('changed', @render, this)
    #@collection.on('add', @render, this)

  render: ->
    console.log("render")
    rendertContent = @template(testo: @model.get("name"))
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    this

