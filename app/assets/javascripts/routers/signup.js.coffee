class Tapesfm.Routers.Signup extends Backbone.Router
  routes:
    'signup:query' : 'signup'


  initialize: ->
    #console.log "init routes"
  signup: (id,params) ->
    #id = "testid"
    #console.log params.invite

    @invite = new Tapesfm.Models.User(Tapesfm.bootstrap.invite)

    view = new Tapesfm.Views.Signup(model: @invite)
    $('#container').html(view.render().el)
    $("label").inFieldLabels()
    $("#name").alphanumeric()
    $("#name").focus()
    #$('#container').html("Settings done")
    # $('#check_icon_password').typing
    #   start:(event, $elem) ->
    #     console.log "start typing"
    #   stop: (event, $elem) ->
    #     console.log "stop typing"
    #     
    #   delay: 500



    #$('h1').html(view2.render().el)



