class Tapesfm.Views.Settings extends Backbone.View
  template: JST['settings/settings']

  events:
    "change .setting_picture_input" : "submitPicture"
    "click .submit_settings" : "submitSettings"
  initialize: ->
  addInFieldlabels: (e) ->
    $(e.currentTarget).parent().find("label").inFieldLabels()


  submitSettings: (e) ->
    email = $(@el).find("#user_email").val()

    password = $(@el).find("#user_password").val() if $(@el).find("#user_password").val() == $(@el).find("#user_password_confirm").val()

    about = $(@el).find("#user_about").val()
    twitter = $(@el).find("#user_twitter").val()
    soundcloud = $(@el).find("#user_soundcloud").val()
    facebook = $(@el).find("#user_facebook").val()


    @model.set({email: email, about: about,twitter_name: twitter, soundcloud_name: soundcloud, facebook_name: facebook})
    if password && password != undefined
      @model.set({password: password})

    @model.save()


  submitPicture: (e) ->
    e.preventDefault()
    console.log $(@el).find(".profile_picture_form").first()

    $(@el).find(".profile_picture_form").ajaxSubmit
      success: (e) =>
        console.log e

        #@model.set({cover_s: e.cover.s.url, cover_m: e.cover.m.url, cover: e.cover.m.url, id: e._id})


        #$(@el).find(".cover_pic").replace("ddsad")#attr("src", ("http://"+e.cover.url))
        # $(@el).find(".cover_pic").attr('src', ("http://"+e.cover.url))
        # $(@el).find(".cover_pic").show(500)
        # $(@el).find(".cover_label").addClass("active")
        # $(@el).find(".cover_pic").removeClass("inactive")

        # console.log "http://"+e.cover.m.url
        #$(@el).find(".cover_pic").hide()
        


  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    $(@el).find("input").focus().blur()


    this




