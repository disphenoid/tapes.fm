class Tapesfm.Routers.Login extends Backbone.Router
  @tapedeck
  routes:
    '/login' : 'login'
  events:
    'submit form': 'login'
  initialize: ->
    #console.log "init routes"
    @model = new Tapesfm.Models.UserSession()

  login: (id) ->
    


  loadTape: ->
    #Loads tape soundManager.onready
    view = new Tapesfm.Views.TapedeckTape(model: @model)
    $('#container').html(view.render().el)
  





