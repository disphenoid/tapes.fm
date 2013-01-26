class Tapesfm.Routers.Tracks extends Backbone.Router

  initialize: ->
    #console.log "init routes"
    #alert "search bar"
    if Tapesfm.user
      @collection = new Tapesfm.Collections.Tracks
      view = new Tapesfm.Views.UserTracks(collection: @collection)
    # $('#user_tracks').append(view.render().el)






