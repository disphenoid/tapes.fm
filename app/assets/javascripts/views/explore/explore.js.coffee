class Tapesfm.Views.Explore extends Backbone.View
  template: JST['explore/explore']

  initialize: ->
  render: ->
    rendertContent = @template(model: @model = new Tapesfm.Models.User)
    $(@el).html(rendertContent)


    this





