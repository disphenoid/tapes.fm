class Tapesfm.Views.DashboardInvites extends Backbone.View
  template: JST['dashboard/invites']

  initialize: ->
    @collection.on("remove", @render, this)
    @collection.on("change:accepted", @removeInvite, this)



    
  removeInvite: (invite) ->
    @collection.remove(invite)
  addInvite: (invite) ->
   inviteView = new Tapesfm.Views.DashboardInvite(model: invite)
   $(@el).find('.dashboard_content').prepend(inviteView.render().el)

    
  
  render: ->
   rendertContent = @template()
   $(@el).html(rendertContent)

   @collection.each @addInvite, this
   console.log @collection.length
   if @collection.length == 0
    $("#dashboard_invites").slideUp("slow")
   else
    $("#dashboard_invites").slideDown("slow")

   #$(@el).find(".dashboard_content").html("dsads")
   
   
   this


