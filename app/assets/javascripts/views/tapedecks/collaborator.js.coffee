class Tapesfm.Views.TapedeckCollaborator extends Backbone.View
  template: JST['tapedecks/collaborator']
  events: ->
    "click .remove_collaborator" : "removeCollaborator"
    
  initialize: ->
  removeCollaborator: (e) ->
    Tapesfm.tapedeck.tapedeck.get("collaborators").remove(e)

    @model.url = "/api/collaborators/#{Tapesfm.tapedeck.tapedeck.get("id")}?collaborator=#{@model.get("id")}"
    @model.destroy()
    $(@el).fadeOut("fast")
    $(".tipsy").fadeOut("fast")


  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    $(@el).hide()
    $(@el).fadeIn("fast")
    this


