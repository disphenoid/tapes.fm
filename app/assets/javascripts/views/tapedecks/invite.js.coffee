class Tapesfm.Views.TapedeckInvite extends Backbone.View
  template: JST['tapedecks/invite']
  events: ->
    
  initialize: ->

  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    this



