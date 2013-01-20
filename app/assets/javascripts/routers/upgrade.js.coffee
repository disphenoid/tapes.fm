class Tapesfm.Routers.Upgrade extends Backbone.Router
  routes:
    'upgrade' : 'upgrade'


  initialize: ->
    #console.log "init routes"
  upgrade: (id) ->
    #id = "testid"

    # @settings = new Tapesfm.Models.Setting(Tapesfm.bootstrap.settings)

    view = new Tapesfm.Views.Upgrade()
    $('#container').html(view.render().el)
    # $('#container').html("Settings done")



    #$('h1').html(view2.render().el)



