class Tapesfm.Views.DashboardStream extends Backbone.View
  template: JST['dashboard/stream']

  initialize: ->
    @collection.on("remove", @render, this)
    @collection.on("change:accepted", @removeInvite, this)

    
  removeInvite: (invite) ->
    @collection.remove(invite)


  addActivity: (activity) ->
   activityView = new Tapesfm.Views.DashboardActivity(model: activity)
   #$(@el).find('#stream_list').prepend("activity")
   $(@el).find('#stream_list').append(activityView.render().el)

    
  
  render: ->
   rendertContent = @template()
   $(@el).html(rendertContent)

   @collection.each @addActivity, this
   #console.log @collection.length


   #$(@el).find(".dashboard_content").html("dsads")
   
   
   this



