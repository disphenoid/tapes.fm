class Tapesfm.Views.InfoStart extends Backbone.View
  template: JST['information/start']

  initialize: ->

  render: ->
   rendertContent = @template()

   $(@el).html(rendertContent)
   this



