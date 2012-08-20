class Tapesfm.Models.Tapedeck extends Backbone.Model
  urlRoot: '/api/tapedeck'
  initialize: ->
    #this.set({ 'tape' : new Tapesfm.Models.Tape(this.get('tape')) })
    #@tape = new Tapesfm.Models.Tape()
  parse: (response) ->  # function definition
    # convert each object attribute into a Model or Collection
    if _.isArray response
      _.each response, (obj) ->
        obj.tape = new Tapesfm.Models.Tape obj.tape
    else
      response.tape = new Tapesfm.Models.Tape response.tape

    return response
