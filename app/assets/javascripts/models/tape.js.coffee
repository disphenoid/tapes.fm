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
        obj.comments = new Tapesfm.Collections.Comments obj.comments
    else
      response.tracks = new Tapesfm.Collections.Tracks response.tracks
      response.comments = new Tapesfm.Collections.Comments response.comments

    return response
