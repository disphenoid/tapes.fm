class Tapesfm.Views.Dashboard extends Backbone.View
  template: JST['dashboard/dashboard']

  initialize: ->



  render: ->
   rendertContent = @template()
   $(@el).html(rendertContent)
   this
