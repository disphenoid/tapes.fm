class Tapesfm.Views.TapedeckCollaborators extends Backbone.View
  template: JST['tapedecks/collaborators']
  events: ->
    "click #invite_send_button" : "createCollaborator"
    "focus #invite_field" : "focusField"
    "blur #invite_field" : "blurField"
    "click #open_button" : "openField"
  initialize: ->
    @collection.on("add", @render,this)
    @collection.on("reset", @render,this)
    @collection.on("remove", @render,this)

  openField: (e) ->

   $(@el).find("#tapedeck_invite_add").fadeTo("slow",1)
   $(".collaborators").animate({marginTop: "50px"})
   $(e.currentTarget).animate({marginTop: "50px"})

  focusField: (e) =>
    $("#invite_send_button").fadeIn("slow")

  blurField: (e) =>
    if $(e.currentTarget).val() == ""
      $("#invite_send_button").fadeOut("fast")

  createCollaborator: (e) ->
    #alert "add " + $("#invite_field").val()

    invite = new Tapesfm.Models.Invite()
    invite.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
    invite.set({value: $("#invite_field").val()})
    invite.save()

    $("#invite_field").val("").focus().blur()

    Tapesfm.tapedeck.tapedeck.get("collaborators").fetch()

    #@collection.fetch()

  appendCollaborator: (user) ->
    user.set({accepted: false},{silent: true})
    collaboratorView = new Tapesfm.Views.TapedeckCollaborator(model: user)
    $('#collaborators').append(collaboratorView.render().el)


  removeCollaborator: (user) ->

    $(".collaborator##{user.get("id")}").hide "slow", ->
      $(this).remove()

    #Tapesfm.tapedeck.tapedeck.get("collaborators").fetch()
  render: ->
    rendertContent = @template(collaborator: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    $('#collaborators').html("")
    $(".collaborators").animate({marginTop: "7px"}, 0)
    $(@el).find("#invite_send_button").hide()

    @collection.each @appendCollaborator
    


    this



