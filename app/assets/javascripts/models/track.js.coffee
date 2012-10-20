class Tapesfm.Models.Track extends Backbone.Model
  urlRoot: '/api/tracks'
  initialize: ->
    #this.set({ 'tape' : new Tapesfm.Models.Tape(this.get('tape')) })
    #@tape = new Tapesfm.Models.Tape()
  parse: (response) ->  # function definition
    # convert each object attribute into a Model or Collection
    if _.isArray response
      _.each response, (obj) ->
        obj.comments = new Tapesfm.Collections.Comments obj.comments
    else
      response.comments = new Tapesfm.Collections.Comments response.comments

    return response
