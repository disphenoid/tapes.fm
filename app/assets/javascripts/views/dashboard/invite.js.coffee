class Tapesfm.Views.DashboardInvite extends Backbone.View
  template: JST['dashboard/invite']

  events:
    "click .decline" : "declineInvite"
    "click .accept" : "acceptInvite"
  initialize: ->


  acceptInvite: (e) ->
   @model.save {accepted: true},

    success: (model,response) ->
      #@model.trigger("")

   console.log "go"
    
  declineInvite: (e) ->
   @model.destroy()


  render: ->
   rendertContent = @template(tape: @model)
   $(@el).html(rendertContent)
   this


