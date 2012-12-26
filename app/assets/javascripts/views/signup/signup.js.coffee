class Tapesfm.Views.Signup extends Backbone.View
  template: JST['signup/signup']
  events:
    "keyup #name" : "checkName"
    "keyup #password" : "checkPassword"

  
  initialize: ->
  
  checkName: (e) ->
  
  checkPassword: (e) ->
    count = $(e.currentTarget).val().length
    if count >= 6
      $("#check_icon_password").removeClass("fail")
      $("#check_icon_password").addClass("ok")
    else
      $("#check_icon_password").removeClass("ok")
      $("#check_icon_password").addClass("fail")



  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    
    # $(@el).find("input").focus().blur()


    this





