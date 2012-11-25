class Tapesfm.Routers.Explore extends Backbone.Router
  routes:
    'explore' : 'explore'


  initialize: ->
    #console.log "init routes"
  explore: (id) ->
    #id = "testid"

    #@settings = new Tapesfm.Models.Setting(Tapesfm.bootstrap.settings)
    @top = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.top_tapes)
    @active = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.active_tapes)
    @new = new Tapesfm.Collections.Tapedecks(Tapesfm.bootstrap.new_tapes)

    view = new Tapesfm.Views.Explore()
    $('#container').html(view.render().el)
    
    activeListView = new Tapesfm.Views.ExploreList(collection: @active, title: "Active")
    $('#container').append(activeListView.render().el)

    topListView = new Tapesfm.Views.ExploreList(collection: @top, title: "Featured")
    $('#container').append(topListView.render().el)


    newListView = new Tapesfm.Views.ExploreList(collection: @new, title: "New")
    $('#container').append(newListView.render().el)

# 
#     activeListView = new Tapesfm.Views.ExploreList()
#     $('#container').append(activeListView.render().el)
    
    #$('#container').html("Settings done")



    #$('h1').html(view2.render().el)



