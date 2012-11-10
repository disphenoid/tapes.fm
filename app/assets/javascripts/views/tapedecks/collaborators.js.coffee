class Tapesfm.Views.TapedeckCollaborators extends Backbone.View
  template: JST['tapedecks/collaborators']
  events: ->
    "click #invite_send_button" : "createCollaborator"
    "focus #invite_field" : "focusField"
    "blur #invite_field" : "blurField"
  initialize: ->
    @collection.on("add", @appendCollaborator,this)
    @collection.on("reset", @render,this)
    @collection.on("remove", @removeCollaborator,this)

  focusField: (e) =>
    $("#invite_send_button").fadeIn("slow")

  blurField: (e) =>
    if $(e.currentTarget).val() == ""
      $("#invite_send_button").fadeOut("fast")

  createCollaborator: (e) ->
    #alert "add " + $("#invite_field").val()

    col = new Tapesfm.Models.Invite()
    col.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
    col.set({value: $("#invite_field").val()})
    col.save()

    $("#invite_field").val("").focus().blur()
    Tapesfm.tapedeck.tapedeck.get("collaborators").fetch()

    #@collection.fetch()

  appendCollaborator: (user) ->
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
    $(@el).find("#invite_send_button").hide()

    @collection.each @appendCollaborator
    


    this



