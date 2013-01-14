class Tapesfm.Views.InfoFAQ extends Backbone.View
  template: JST['information/faq']

  initialize: ->

  render: ->
   rendertContent = @template()
   $(@el).html(rendertContent)
   this





