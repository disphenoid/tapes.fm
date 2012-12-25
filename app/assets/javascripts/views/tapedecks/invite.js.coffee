class Tapesfm.Views.TapedeckInvite extends Backbone.View
  template: JST['tapedecks/collaborator']
  events: ->
    "click .remove_collaborator" : "removeCollaborator"
    
  initialize: ->
  removeCollaborator: (e) ->

    
    
    invite = new Tapesfm.Models.Invite()
    invite.set("id", @model.get("id"))
    invite.destroy()
    Tapesfm.tapedeck.tapedeck.get("collaborators").remove(invite)
    $(@el).fadeOut("fast")
    $(".tipsy").remove()
    


  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    $(@el).hide()
    $(@el).fadeIn("fast")
    this



