class Tapesfm.Views.TapedeckLicense extends Backbone.View
  template: JST['tapedecks/license']


  initialize: ->



  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    this



