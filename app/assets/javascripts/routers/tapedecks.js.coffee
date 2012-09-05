class Tapesfm.Routers.Tapedecks extends Backbone.Router
  @tapedeck
  routes:
    'tapedeck/:id' : 'tapedeck'
  initialize: ->
    #console.log "init routes"
  tapedeck: (id) ->
    #id = "testid"
    #@tapedeck = new Tapesfm.Models.Tapedeck(id:id)
    
    # Tapedeck
    window.td = @tapedeck = new Tapesfm.Models.Tapedeck(Tapesfm.bootstrap)
    @tapedeck.set({id:id})

    # Current set Tape
    if Tapesfm.bootstrap.tape.id
      @tapedeck.attributes.tape = new Tapesfm.Models.Tape(Tapesfm.bootstrap.tape)
      @tapedeck.attributes.tape.set({id:Tapesfm.bootstrap.tape._id})
      @tapedeck.attributes.tape.set({_id:Tapesfm.bootstrap.tape._id})
      @tapedeck.attributes.tape.attributes.tracks = new Tapesfm.Collections.Tracks(Tapesfm.bootstrap.tape.tracks)
    else
      @tapedeck.attributes.tape = new Tapesfm.Models.Tape()
      @tapedeck.attributes.tape.set({id:"0"})
      @tapedeck.attributes.tape.set({_id:"0"})
      @tapedeck.attributes.tape.set({"tapedeck_id":id})
      @tapedeck.attributes.tape.attributes.tracks = new Tapesfm.Collections.Tracks()
      

    # List of all Versions
    @tapedeck.attributes.versions = new Tapesfm.Collections.Versions(Tapesfm.bootstrap.versions)
    @tapedeck.get("versions").url = "/api/versions/"+ @tapedeck.get("id")

        
    view = new Tapesfm.Views.Tapedeck(model: @tapedeck)
    $('#container').html(view.render().el)

    headerView = new Tapesfm.Views.TapedeckHeader(model: @tapedeck)
    $('#tapedeck_header').html(headerView.render().el)
    
    #editView = new Tapesfm.Views.TapedeckEdit(model: @tapedeck)
    #$('#tapedeck_current_version').html(editView.render().el)
    versionsView = new Tapesfm.Views.TapedeckVersions(model: @tapedeck)
    $('#tapedeck_current_version').html(versionsView.render().el)



  loadTape: ->
    #Loads tape soundManager.onready
    tapeView = new Tapesfm.Views.TapedeckTape(model: @tapedeck)
    $('#tapedeck_tape').html(tapeView.render().el)
  
  newTapeWidthTrack: (track) ->
    
    #coping Tape

    new_track = new Tapesfm.Models.Track(track)

    tape = Tapesfm.tapedeck.tapedeck.get("tape")
    tape.get("tracks").unshift new_track

    if tape.get("track_ids")
      tape.get("track_ids").push(new_track.get("id"))
    else
      tape.set({"track_ids":[]},{silent: true})
      tape.get("track_ids").push(new_track.get("id"))
    
    tape.set({name:"#{tape.get("name")} copy"})
    tape.set({id:undefined})
    tape.set({_id:undefined})
    #modefiy values
    



