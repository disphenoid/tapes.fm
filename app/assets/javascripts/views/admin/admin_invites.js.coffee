class Tapesfm.Views.AdminInvites extends Backbone.View
  template: JST['admin/users/invites']
  className: "admin_user_box"

  initialize: ->
    # alert @options.count
  
  appendInvite: (invite) ->
   requestView = new Tapesfm.Views.AdminInvite(model: invite)
   @$('#invites').prepend(requestView.render().el)
  
  render: ->
    rendertContent = @template(count: @options.count)
    $(@el).html(rendertContent)

    @collection.each @appendInvite, this

    this







