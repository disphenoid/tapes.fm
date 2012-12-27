class Tapesfm.Views.AdminUsers extends Backbone.View
  template: JST['admin/users/users']
  className: "admin_user_box"

  initialize: ->
  
  appendUser: (user) ->
   userView = new Tapesfm.Views.AdminUser(model: user)
   @$('#users').append(userView.render().el)
  
  render: ->
    rendertContent = @template(count: @options.count)
    $(@el).html(rendertContent)

    @collection.each @appendUser, this
    # @$('#requests').append("ddd")

    this







