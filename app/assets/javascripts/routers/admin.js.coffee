class Tapesfm.Routers.Admin extends Backbone.Router
  routes:
    'admin/users' : 'users'


  initialize: ->
    #console.log "init routes"
  stats: () ->


  users: () ->
    #id = "testid"

    #@settings = new Tapesfm.Models.Setting(Tapesfm.bootstrap.settings)
    # @top = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.top_tapes)
    @requests = new Tapesfm.Collections.Requests(Tapesfm.bootstrap.requests)
    @invites = new Tapesfm.Collections.Invites(Tapesfm.bootstrap.invites)
    @users = new Tapesfm.Collections.Users(Tapesfm.bootstrap.users)

    requestsView = new Tapesfm.Views.AdminRequests(collection: @requests, count: Tapesfm.bootstrap.request_count)
    $('#container').append(requestsView.render().el)
    
    invitesView = new Tapesfm.Views.AdminInvites(collection: @invites, count: Tapesfm.bootstrap.invite_count)
    $('#container').append(invitesView.render().el)

    usersView = new Tapesfm.Views.AdminUsers(collection: @users, count: Tapesfm.bootstrap.user_count)
    $('#container').append(usersView.render().el)

    # 
    # activeListView = new Tapesfm.Views.ExploreList(collection: @active, title: "Active")
    # $('#container').append(activeListView.render().el)

    # topListView = new Tapesfm.Views.ExploreList(collection: @top, title: "Featured")
    # $('#container').append(topListView.render().el)


    # newListView = new Tapesfm.Views.ExploreList(collection: @new, title: "New")
    # $('#container').append("ddd")

# 
#     activeListView = new Tapesfm.Views.ExploreList()
#     $('#container').append(activeListView.render().el)
    
    #$('#container').html("Settings done")



    #$('h1').html(view2.render().el)




