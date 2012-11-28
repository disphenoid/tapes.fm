class Tapesfm.Views.DashboardInvite extends Backbone.View
  template: JST['dashboard/invite']
  tagName: "li"
  className: "dashboard_tape"
  events:
    "click .decline" : "declineInvite"
    "click .accept" : "acceptInvite"
  initialize: ->


  acceptInvite: (e) ->
   @model.save {accepted: true},

    success: (model,response) ->
      #@model.trigger("")
  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
    
    switch index
      when 0 then "one"
      when 1 then "two"
      when 2 then "three"
      when 3 then "four"
      else ""
    
  declineInvite: (e) ->
   @model.destroy()


  render: ->
   rendertContent = @template(tape: @model)

   $(@el).html(rendertContent)
   $(@el).addClass(@getIndex())
   this


