class Tapesfm.Models.Tape extends Backbone.Model
  initialize: ->
    @versions = new Backbone.Collection()
    @tracks = new Backbone.Model()
    @comments = new Backbone.Collection()
