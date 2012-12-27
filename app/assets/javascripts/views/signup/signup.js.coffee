class Tapesfm.Views.Signup extends Backbone.View
  template: JST['signup/signup']
  events:
    "keyup #password" : "checkPassword"
    "click #submit" : "createUser"
    # "keyup #name" : "checkName"

  
  initialize: ->
  
  createUser: (e) ->

    if $("#check_icon_name").hasClass("ok") && $("#check_icon_password").hasClass("ok") && ($("#terms").attr('checked') == "checked")
    
      user = new Tapesfm.Models.User()
      user.set({name: $("#name").val()})
      user.set({password: $("#password").val()})
      user.set({hash: @model.get("hash")})
      $("#submit").addClass("active")
      $("#submit").attr("disabled", "disabled")
      user.save(
        {}
        {success: (model, response) =>
           console.log response
           if response.created == true
             window.location.href = "/"

        })
    else
      if $("#check_icon_name").hasClass("fail") && $("#check_icon_password").hasClass("fail")
        alert "Name is already taken and Password is too short."
      else if $("#check_icon_name").hasClass("fail") || $("#check_icon_password").hasClass("fail")
        if $("#check_icon_name").hasClass("fail")
          alert "Name is already taken."
        else
          alert "Password is too short."
      else
          alert "Please accept the Terms of service."

  
  checkName: (e) ->
    # if $(e.currentTarget).val()
      # jQuery.getJSON ("/api/user_name_unique/#{$(e.currentTarget).val()}.json?callback=?"), (data) ->
      #   console.log "data coming"
      #   console.log data




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


    $(@el).find('#name').typing
      start:(e, $elem) =>
        console.log "start typing"
        $("#check_icon_name").removeClass("ok")
        $("#check_icon_name").removeClass("fail")
        $("#check_icon_name").addClass("loading")
      stop: (e, $elem) =>
        count = $(e.currentTarget).val().length
        if $(e.currentTarget).val() && count > 3

          jQuery.ajax
            url: "/api/user_name_unique/#{$(e.currentTarget).val()}"
            success: (data) ->
              # console.log data
              $("#check_icon_name").removeClass("loading")


              if data == "true"
                # console.log "is true"
                $("#check_icon_name").removeClass("fail")
                $("#check_icon_name").addClass("ok")

              else
                $("#check_icon_name").removeClass("ok")
                $("#check_icon_name").addClass("fail")
                # console.log "is false"
        else
          $("#check_icon_name").removeClass("ok")
          $("#check_icon_name").removeClass("loading")
          $("#check_icon_name").addClass("fail")

        
      delay: 500


    this





