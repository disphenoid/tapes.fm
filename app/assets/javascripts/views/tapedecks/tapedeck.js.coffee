class Tapesfm.Views.Tapedeck extends Backbone.View
  template: JST['tapedecks/tapedeck']

  initialize: ->
    window.bla = @model.on('change', @updateChange, this)
   
  updateChange: ->
    console.log("render2")
    rendertContent = @template(tapedeck: @model)
    $(@el).html(rendertContent)
    this
  render: ->
    #name = @model.get("name")
    this
