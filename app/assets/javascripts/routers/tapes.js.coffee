class Tapesfm.Routers.Tapes extends Backbone.Router
  routes:
    'tapedeck/:id' : 'tapedeck'
  initialize: ->
    #console.log "init routes"
  tapedeck: (id) ->
    #id = "testid"
    @tapes = new Tapesfm.Collections.Tapes()
    @tapes.fetch()
    @tape = new Tapesfm.Models.Tape()
    @tape.set({"name":String(id)})

    view = new Tapesfm.Views.TapesIndex(collection: @tapes )
    #view2 = new Tapesfm.Views.TapesTracks(model: @tape)

    $('#container').html(view.render().el)
    #$('h1').html(view2.render().el)

