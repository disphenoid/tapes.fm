class Tapesfm.Views.AdminInvite extends Backbone.View
  template: JST['admin/users/invite']

  initialize: ->
  

  
  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)

    this








