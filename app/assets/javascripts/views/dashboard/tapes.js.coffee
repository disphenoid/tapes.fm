class Tapesfm.Views.DashboardTapes extends Backbone.View
  template: JST['dashboard/tapes']

  initialize: ->



  addTape: (tape) ->
   tapeView = new Tapesfm.Views.DashboardTape(model: tape)
   $(@el).find('.dashboard_content').prepend(tapeView.render().el)

    
  
  render: ->
   rendertContent = @template()
   $(@el).html(rendertContent)

   @collection.each @addTape, this
   #$(@el).find(".dashboard_content").html("dsads")
   
   
   this

