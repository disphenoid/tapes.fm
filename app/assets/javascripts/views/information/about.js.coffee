class Tapesfm.Views.InfoAbout extends Backbone.View
  template: JST['information/about']

  initialize: ->

  render: ->
   rendertContent = @template() 
   $(@el).html(rendertContent)
   this




