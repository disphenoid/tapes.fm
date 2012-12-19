class Tapesfm.Views.AdminRequest extends Backbone.View
  template: JST['admin/users/request']

  initialize: ->
  

  
  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)

    this








