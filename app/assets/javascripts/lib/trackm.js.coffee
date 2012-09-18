class Trackm
  sm: undefined
  tempPosition: 0
  constructor: (soundManager) ->
    @sm = soundManager

  duration: 0
  trackWidth: 700
  leadTrack: null
  tracks: []
  
  setMaxTrackLength: (tracks_array) ->
    tracks_array.each (track) =>
      if Number(track.get("duration")) > @duration
        @duration = Number(track.get("duration"))


    #@duration = 456

  muteTrack: (track_id) ->
    @sm.mute(@tracks[track_id-1].id)

  unmuteTrack: (track_id) ->
    @sm.unmute(@tracks[track_id-1].id)

  soloTrack: (track_id) ->
    #@sm.mute(@tracks[track_id-1].id)
    @checkSolo()
  unsoloTrack: (track_id) ->
    @checkSolo()
    #@sm.unmute(@tracks[track_id-1].id)
  volumeTrack: (track_id,vol) ->
    @sm.setVolume(@tracks[track_id-1].id,vol)

  panTrack: (track_id,pan) ->
    @sm.setPan(@tracks[track_id-1].id,pan)

  checkSolo: ->
    isSolo = false

    $(".solo").each (index,soloElement) =>
      
      #index = index
      track_id = Tapesfm.trackm.tracks[index].id

      if $(soloElement).hasClass("active")
        isSolo = true
        @sm.unmute(track_id)
        console.log "#{track_id} is solo inde = #{index}"
      else
        @sm.mute(track_id)
      
    unless isSolo
      $(".solo").each (index,soloElement) =>
        if Tapesfm.tapedeck.tapedeck.get("tape").get("mute_#{index+1}")
          #@muteTrack()
          @sm.mute(@tracks[index].id)
        else
          @sm.unmute(@tracks[index].id)
          #@unmuteTrack()



  addTrack: (track) ->
    if Number(track.duration) == Number(@duration)

      @track = @sm.createSound
        id: track.name
        url: track.url
        volume: track.toptions.volume
        pan: track.toptions.pan
        autoLoad: true
        whileloading: @loading
        whileplaying: @position
        onfinish: @finish

      if track.toptions.mute
        @sm.mute(@track.id)

      @leadTrack = @track

    else

      @track = @sm.createSound
        id: track.name
        url: track.url
        volume: track.toptions.volume
        pan: track.toptions.pan
        autoLoad: true
        whileloading: @loading
      if track.toptions.mute
        @sm.mute(@track.id)

    @track.staticDuration = track.duration
    @tracks.push @track
    #$(".mute_1").hide()
    


  removeTrack: (track_id) ->
    @stop()
    _.each @tracks, (t) =>
      if t.id == track_id
        idx = @tracks.indexOf(t)
        @tracks.splice(idx,1)
        @sm.destroySound(track_id)
        console.log "Track removed"
        return true
      else
        return false
  clearTracks: ->
    @stop()
    _.each @tracks, (t) =>
      @sm.destroySound(t.id)
    @tracks = []
    @duration = 0
    @leadTrack = null
        
  play: ->

    # Start Play on all Tracks 
    _.each @tracks, (t) =>
      console.log("Play – "+t.id)
      @sm.play(t.id)
      
    #console.log("play")
    #
  pause: ->
    _.each @tracks, (t) =>
      console.log("Stop – "+t.id)
      @sm.pause(t.id)

  resume: ->
    _.each @tracks, (t) =>
      console.log("Resume – "+t.id)
      @sm.resume(t.id)

  stop: ->
    _.each @tracks, (t) =>
      console.log("Stop – "+t.id)
      @sm.stop(t.id)
      @sm.setPosition(t.id, 0)

      $(("#"+t.id+"_progress")).css({width: 0})
      $("#scrabber_position").css({left: 0})
      $("#scrabber_label").css({left: 0})
      $("#scrabber_label").html(window.tools.toTime(0))


  seek: (pixel_pos) ->
    baseWidth = 700

    loaded = true
    position = window.tools.map(pixel_pos, 0, Number(baseWidth), 0,  @leadTrack.duration)

    _.each @tracks, (t) =>
      if position < t.duration
        loaded = true
      else
        loaded = false

    if true

      val = window.tools.map(position, 0, @leadTrack.duration, 0, Number(baseWidth))
      playstate = Tapesfm.trackm.leadTrack.playState
      paused = Tapesfm.trackm.leadTrack.paused

      _.each @tracks, (t) =>
        console.log("Seek – "+t.id)

        @sm.stop(t.id)
        @sm.setPosition(t.id, position)

        if position <= t.duration
          
          if playstate && !paused
            @sm.play(t.id)

          $(("#"+t.id+"_progress")).css({width: val})
        else
          $(("#"+t.id+"_progress")).css({width: $(("#"+t.id+"_clip")).width()})



    if true
      
      $("#scrabber_position").css({left: val})
      $("#scrabber_label").css({left: val})
      $("#scrabber_label").html(window.tools.toTime(position))

      return true
    else
      return false
  position: ->

    baseWidth = 700
    #console.log "position = "+ String(this.position) + " / " + String(this.durationEstimate)
    
    val = window.tools.map(this.position, 0, this.durationEstimate, 0, Tapesfm.trackm.trackWidth)
    $("#scrabber_position").css({left: val})
    $("#scrabber_label").css({left: val})
    $("#scrabber_label").html(window.tools.toTime(this.position))
    _.each window.Tapesfm.trackm.tracks, (t) =>
      unless Number(val) > Number($(("#"+t.id+"_clip")).width())
        $(("#"+t.id+"_progress")).css({width: val})
      else
        $(("#"+t.id+"_progress")).css({width: $(("#"+t.id+"_clip")).width()})


  loading: ->
    baseWidth = Tapesfm.trackm.trackWidth
        
    console.log "VALUE== "+this.id

    tWidth = $(("#"+this.id+"_clip")).width()


    val = window.tools.map(this.bytesLoaded, 0, this.bytesTotal, 0, tWidth)

    $(("#"+this.id+"_loaded")).css({width: val})
    #val = window.tools.map(300, 0,400,0,1000)
    #console.log Math.round(val)

  finish: ->
    #alert "end"
    Tapesfm.trackm.stop()
jQuery ->
  soundManager.setup
    url: "/assets/"
    flashVersion: "9"
    useFlashBlock: false
    onready: ->
      window.Tapesfm.trackm = new Trackm(soundManager)
      Tapesfm.tapedeck.loadTape()
      # window.Tapesfm.trackm.addTrack {name:"track2",url:"/assets/army_drums.mp3" }
      # window.Tapesfm.trackm.addTrack {name:"track3",url:"/assets/army_vox.mp3" }
      # window.Tapesfm.trackm.addTrack {name:"track4",url:"/assets/army_vox.mp3" }



