class Tapesfm.Views.TapedeckVersion extends Backbone.View
  template: JST['tapedecks/version']
  events:
    "click .tape_version_el" : "changeTape"  
  changeTape: (data) ->
  initialize: ->
    #alert $(data).data("id")
    #console.log $(data.target).data("id")
  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    this


