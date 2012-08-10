class Tapesfm.Routers.Tapedecks extends Backbone.Router
  routes:
    'tapedeck/:id' : 'tapedeck'
  initialize: ->
    #console.log "init routes"
  tapedeck: (id) ->
    #id = "testid"
    @tapedeck = new Tapesfm.Models.Tapedeck(id:id)
    @tapedeck.fetch()

    #@tape = new Tapesfm.Models.Tape()
    #@tape.set({"name":String("no")})

    view = new Tapesfm.Views.Tapedeck(model: @tapedeck)
    $('#container').html(view.render().el)

