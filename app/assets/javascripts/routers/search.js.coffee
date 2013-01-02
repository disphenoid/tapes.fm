class Tapesfm.Routers.Search extends Backbone.Router
  routes:
    'search' : 'search'
  initialize: ->
    #console.log "init routes"
    #alert "search bar"
    view = new Tapesfm.Views.Search()
    #$('#container').append(view.render().el)


  tapes: (id) ->
    # id = "testid"
    alert "search"
    # @tapes = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.tapedecks)

    # view = new Tapesfm.Views.Tapes(collection: @tapes)
    # $('#container').html(view.render().el)



    #$('h1').html(view2.render().el)


