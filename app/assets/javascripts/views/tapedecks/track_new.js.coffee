class Tapesfm.Views.TrackNew extends Backbone.View
  template: JST['tapedecks/track_new']
  tagName: "li"
  className: "track_new"

  initialize: ->

  render: ->
    rendertContent = @template()
    $(@el).html(rendertContent)
    this
