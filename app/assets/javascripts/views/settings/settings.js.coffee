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

  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    $(@el).find("input").focus().blur()

    this




