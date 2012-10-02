class Tapesfm.Views.TapedeckDownload extends Backbone.View
  template: JST['tapedecks/download']
  tagName: "li"
  events: ->
  initialize: ->

  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    this




