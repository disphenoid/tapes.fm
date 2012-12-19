class Tapesfm.Views.AdminUser extends Backbone.View
  template: JST['admin/users/user']

  initialize: -> 

  
  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)


    this








