class Tapesfm.Views.DashboardTape extends Backbone.View
  template: JST['dashboard/tape']

  initialize: ->



  render: ->
   rendertContent = @template(tape: @model)
   $(@el).html(rendertContent)
   this

