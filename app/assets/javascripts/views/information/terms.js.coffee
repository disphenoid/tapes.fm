class Tapesfm.Views.InfoTerms extends Backbone.View
  template: JST['information/terms']

  initialize: ->

  render: ->
   rendertContent = @template()

   $(@el).html(rendertContent)
   this




