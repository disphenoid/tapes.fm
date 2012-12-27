class Tapesfm.Views.AdminRequests extends Backbone.View
  template: JST['admin/users/requests']
  className: "admin_user_box"

  initialize: ->
  
  appendRequest: (request) ->
   requestView = new Tapesfm.Views.AdminRequest(model: request)
   @$('#requests').prepend(requestView.render().el)
  
  render: ->
    rendertContent = @template(count: @options.count)
    $(@el).html(rendertContent)

    @collection.each @appendRequest, this

    this







