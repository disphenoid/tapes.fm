class Tapesfm.Routers.Dashboard extends Backbone.Router
  routes:
    'dashboard' : 'dashboard'
  initialize: ->
    #console.log "init routes"
  dashboard: (id) ->
    #id = "testid"

    @latest_tapes = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.lates_tapes)
    @invites = new Tapesfm.Collections.Invites(Tapesfm.bootstrap.invites)


    view = new Tapesfm.Views.Dashboard()
    $('#container').html(view.render().el)
    
    $("#dashboard_invites").show(0) if @invites.length > 0

    tapesView = new Tapesfm.Views.DashboardTapes(collection: @latest_tapes)
    $('#dashboard_tapes').html(tapesView.render().el)

    invitesView = new Tapesfm.Views.DashboardInvites(collection: @invites)
    $('#dashboard_invites').html(invitesView.render().el)


    #$('h1').html(view2.render().el)


