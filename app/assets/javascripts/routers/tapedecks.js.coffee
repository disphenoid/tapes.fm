class Tapesfm.Routers.Tapedecks extends Backbone.Router
  @tapedeck
  routes:
    'tapedeck/:id' : 'tapedeck'
  initialize: ->
    #console.log "init routes"
  tapedeck: (id) ->
    #id = "testid"
    #@tapedeck = new Tapesfm.Models.Tapedeck(id:id)
    
    window.td = @tapedeck = new Tapesfm.Models.Tapedeck(Tapesfm.bootstrap)
    @tapedeck.set({id:id})
    @tapedeck.attributes.tape = new Tapesfm.Models.Tape(Tapesfm.bootstrap.tape)
    @tapedeck.attributes.tape.set({id:Tapesfm.bootstrap.tape._id})
    @tapedeck.attributes.tape.attributes.tracks = new Tapesfm.Collections.Tracks(Tapesfm.bootstrap.tape.tracks)
    @tapedeck.attributes.versions = new Tapesfm.Collections.Versions(Tapesfm.bootstrap.versions)
    @tapedeck.get("versions").url = "/api/versions/"+ @tapedeck.get("id")
    #@tapedeck.attributes.tape.attributes.tracks

    #@tapedeck.attributes.tapes = new Tapesfm.Collections.Tapes(Tapesfm.bootstrap.tapes)
    
    view = new Tapesfm.Views.Tapedeck(model: @tapedeck)
    $('#container').html(view.render().el)

    headerView = new Tapesfm.Views.TapedeckHeader(model: @tapedeck)
    $('#tapedeck_header').html(headerView.render().el)
    
    versionsView = new Tapesfm.Views.TapedeckVersions(collection: @tapedeck.get("versions"))
    $('#tapedeck_current_version').append(versionsView.render().el)
     


  loadTape: ->
    #Loads tape soundManager.onready
    tapeView = new Tapesfm.Views.TapedeckTape(model: @tapedeck)
    $('#tapedeck_tape').html(tapeView.render().el)
  




