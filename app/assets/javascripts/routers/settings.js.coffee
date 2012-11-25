class Tapesfm.Routers.Settings extends Backbone.Router
  routes:
    'settings' : 'settings'


  initialize: ->
    #console.log "init routes"
  settings: (id) ->
    #id = "testid"

    @settings = new Tapesfm.Models.Setting(Tapesfm.bootstrap.settings)

    view = new Tapesfm.Views.Settings(model: @settings)
    $('#container').html(view.render().el)
    #$('#container').html("Settings done")



    #$('h1').html(view2.render().el)


