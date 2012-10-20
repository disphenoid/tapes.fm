class Tapesfm.Routers.Tapes extends Backbone.Router
  @tapes
  routes:
    'tapes' : 'tapes'
  initialize: ->
    #console.log "init routes"
  tapes: (id) ->
    #id = "testid"

    @tapes = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.tapedecks)

    view = new Tapesfm.Views.Tapes(collection: @tapes)
    $('#container').html(view.render().el)



    #$('h1').html(view2.render().el)

