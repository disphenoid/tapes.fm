

class Tapesfm.Views.UserTracks extends Backbone.View

  initialize: ->
    
    @collection.on "reset", @resetTracks, this
    @collection.fetch()
    
    # console.log @collection  
  
  reload: () ->  
    @collection.fetch()
  addTrack: (track) ->
    
    # $("#search_results").append(tape.get("name"))
    # tapeView = new Tapesfm.Views.SearchTape(model: tape)
    # $('#search_results').append(tapeView.render().el) 

    trackView = new Tapesfm.Views.UserTrack(model: track)
    $('#user_track_list').append(trackView.render().el)
    

  resetTracks: (e) ->
    if @collection.length > 0
      $('#user_track_list').html("")
    @collection.each @addTrack, this
    
    











