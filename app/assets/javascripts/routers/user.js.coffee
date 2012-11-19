class Tapesfm.Routers.User extends Backbone.Router
  @user
  routes:
    'user/:id' : 'user'


  initialize: ->
    #console.log "init routes"
  user: (id) ->
    #id = "testid"

    @tapes = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.tapedecks)

    view = new Tapesfm.Views.User(collection: @tapes)
    $('#container').html(view.render().el)



    #$('h1').html(view2.render().el)


