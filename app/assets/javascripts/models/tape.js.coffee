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
    else
      response.tracks = new Tapesfm.Collections.Tracks response.tracks

    return response
