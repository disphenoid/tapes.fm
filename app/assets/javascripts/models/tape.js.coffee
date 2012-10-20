class Tapesfm.Models.Tape extends Backbone.Model
  urlRoot: '/api/tapes'
  initialize: ->
    #this.set({ 'tape' : new Tapesfm.Models.Tape(this.get('tape')) })
    #@tape = new Tapesfm.Models.Tape()
  parse: (response) ->  # function definition
    # convert each object attribute into a Model or Collection
    if _.isArray response
      _.each response, (obj) ->
        obj.tracks = new Tapesfm.Collections.Tracks obj.tracks
        obj.track_track = new Tapesfm.Collections.TrackSettings obj.track_settings

        obj.tracks.each (track, index) ->
          track.attributes.comments = new Tapesfm.Collections.Comments(track.attributes.comments)

        obj.comments = new Tapesfm.Collections.Comments obj.comments

    else
      response.tracks = new Tapesfm.Collections.Tracks response.tracks
      response.track_settings = new Tapesfm.Collections.TrackSettings response.track_settings

      response.tracks .each (track, index) ->
        track.attributes.comments = new Tapesfm.Collections.Comments(track.attributes.comments)

      response.comments = new Tapesfm.Collections.Comments response.comments



    

    return response
