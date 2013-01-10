class Tapesfm.Views.TapedeckDownload extends Backbone.View
  template: JST['tapedecks/download']
  tagName: "li"
  className: "download_el"
  events: ->
  initialize: ->
    @model.on('change:name', @render, this)

  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    $(@el).find(".title").trunacat(18, false)
    
    this




