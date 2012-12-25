class Tapesfm.Views.TapedeckCollaborators extends Backbone.View
  template: JST['tapedecks/collaborators']
  events: ->
    "click #invite_send_button" : "createCollaborator"
    "focus #invite_field" : "focusField"
    "blur #invite_field" : "blurField"
    "click #open_button" : "openField"

  constructor: (options) ->
    super
    @render = _.wrap @render, (render) =>
      render()
      @afterRender()
      @


  initialize: ->
    @collection.on("add", @updateCollaborators,this)
    @collection.on("reset", @updateCollaborators,this)
    @collection.on("remove", @removeCollaborator,this)
    # @bind('rendered', @afterRender, this)




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
    invite.save(
      {}
      {success: (model, response) =>
        #console.log "response " + response.id
        #window.location = "/tapedeck/"+response._id
        invite = new Tapesfm.Models.Invite(response)
        invite.set({id: response._id})
        console.log response

        # Tapesfm.tapes.unshift(tapedeck)
        if response._id
          @collection.add(invite)


      })



    $("#invite_field").val("").focus().blur()

    # Tapesfm.tapedeck.tapedeck.get("collaborators").fetch()

    #@collection.fetch()

  appendCollaborator: (collaborator) ->

    unless collaborator.get("accepted")
      inviteView = new Tapesfm.Views.TapedeckInvite(model: collaborator)
      $('#collaborators').append(inviteView.render().el)
    else
      collaboratorView = new Tapesfm.Views.TapedeckCollaborator(model: collaborator)
      $('#collaborators').append(collaboratorView.render().el)



  removeCollaborator: (user) ->

    # $(".collaborator##{user.get("id")}").hide "slow", ->
    #   $(this).remove()

    
    # Tapesfm.tapedeck.tapedeck.get("collaborators").fetch()
    # alert "fetch"
  
  updateCollaborators: ->
    $('#collaborators').html("")
    @collection.each @appendCollaborator
    


  render: =>
    rendertContent = @template(collaborator: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    $('#collaborators').html("")
    $(".collaborators").animate({marginTop: "7px"}, 0)
    $(@el).find("#invite_send_button").hide()

    @collection.each @appendCollaborator
    this

  beforeRender: ->
    # alert "dd"

  afterRender: =>
    # @$('#invite_label').inFieldLabels()
    # alert "# dd"


