class Tapesfm.Views.TapedeckInvites extends Backbone.View
  template: JST['tapedecks/invites']
  events: ->

  initialize: ->

  appendInvites: (invite) ->
   inviteView = new Tapesfm.Views.TapedeckInvite(model: invite)
   $(@el).find('#collaborators').append("ddd")
   
  render: ->
    #rendertContent = @template(inviters: @model)
    #$(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    #$(@el).find("#invite_send_button").hide()

    @collection.each @appendInvites,this
    this




