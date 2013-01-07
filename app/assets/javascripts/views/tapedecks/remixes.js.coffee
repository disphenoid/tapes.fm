class Tapesfm.Views.TapedeckRemixes extends Backbone.View
  template: JST['tapedecks/remixes']

  initialize: ->
    @collection.on "reset", @render, this
    @collection.fetch()

  addTape: (tape) ->
   tapeView = new Tapesfm.Views.TapedeckRemix(model: tape)
   $(@el).find('#remixes').append(tapeView.render().el)

  render: ->
   if @collection.length > 0
     rendertContent = @template()
     $(@el).html(rendertContent)

     @collection.each @addTape, this
     #$(@el).find(".dashboard_content").html("dsads")
     
   
   this


