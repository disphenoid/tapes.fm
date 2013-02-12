window.totalLoadingTracks = {}
window.ready = false
window.waitingForTracks = false
window.loadingReady = () ->
  buffer = 10
  old_ready = window.ready

  # all_status = []
  
  all_stats = {}
  is_read = true

  _.each window.Tapesfm.trackm.tracks, (track) =>
    # console.log = "percent value = #{window.totalLoadingTracks[track.id]}"
    # console.log window.totalLoadingTracks[track.id]
    if window.totalLoadingTracks[track.id] >= buffer
      all_stats[track.id] = true
    else
      all_stats[track.id] = false
      # Tapesfm.trackm.play()
      # ready  = true
  _.each window.Tapesfm.trackm.tracks, (stat) =>
    if all_stats[stat.id] == false
      # console.log "FALSEEEEEEEEEEEEEE"
      is_read = false
      window.ready = false

  # console.log all_stats
  # console.log is_read
  window.ready = is_read

  if old_ready != window.ready 
    $("#pause").removeClass("loading")
    if window.waitingForTracks
      Tapesfm.trackm.play()




  #   console.log "IS READY ??  = " + window.ready
  #   if is_read
  #     window.ready == true
  #     Tapesfm.trackm.play()

  # console.log "IS READY ??  = " + window.ready
  # Tapesfm.trackm.play() if old_ready != window.ready && window.waiting


  window.ready



class window.Trackm
  sm: undefined
  tempPosition: 0
  constructor: (soundManager) ->
    @sm = soundManager

  duration: 0
  completePercent: 0
  trackWidth: 765
  leadTrack: null
  tracks: []
  totalLoadingTracks: {}


  
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
        # console.log "#{track_id} is solo inde = #{index}"
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
        # console.log "Track removed"
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
  
  checkLoaded: (percent, callback) ->

    if true
      callback(this)

  play: ->

    # Start Play on all Tracks 
    if window.ready
      $("#tapedeck_image_wheels").addClass("play")
      _.each @tracks, (t) =>
        # console.log("Play – "+t.id)
        @sm.play(t.id)
    else
      $("#pause").addClass("loading")
      # console.log "NOT LOADED!"
      window.waitingForTracks = true

  


    # @checkLoaded 10, (that) ->
      
    #console.log("play")
    #
  pause: ->
    window.waitingForTracks = false
    $("#tapedeck_image_wheels").removeClass("play")
    if window.ready
      _.each @tracks, (t) =>

        # console.log("Stop – "+t.id)
        @sm.pause(t.id)



  resume: ->

    # window.waitingForTracks = true
    $("#tapedeck_image_wheels").addClass("play")
    if window.ready
      _.each @tracks, (t) =>
        # console.log("Resume – "+t.id)
        @sm.resume(t.id)

  stop: ->
    $("#tapedeck_image_wheels").removeClass("play")
    _.each @tracks, (t) =>
      # console.log("Stop – "+t.id)
      @sm.stop(t.id)
      @sm.setPosition(t.id, 0)

      $(("#"+t.id+"_progress")).css({width: 0})
      # $("#scrabber_position").css({left: 0})
      $(".track_position").css({"margin-left": -42})
      $("#scrabber_label").css({left: 0})
      $("#scrabber_value").html(window.tools.toTime(0))

      $("#pause").hide()
      $("#resume").hide()
      $("#play").show()


  seek: (pixel_pos) ->
    baseWidth = 765

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

      $(".track_position").css({"margin-left": (Number(val) - 42)})
      _.each @tracks, (t) =>
        # console.log("Seek – "+t.id)

        @sm.stop(t.id)
        @sm.setPosition(t.id, position)

        if position <= t.duration
          
          if playstate && !paused
            @sm.play(t.id)

          $(("#"+t.id+"_progress")).css({width: val})
        else
          $(("#"+t.id+"_progress")).css({width: $(("#"+t.id+"_clip")).width()})



    if true
      
      # $("#scrabber_position").css({left: val})
      $(".track_position").css({"margin-left": (Number(val) - 42)})
      $("#scrabber_label").css({left: val})
      $("#scrabber_value").html(window.tools.toTime(position))

      return true
    else
      return false
  position: ->

    baseWidth = 765
    #console.log "position = "+ String(this.position) + " / " + String(this.durationEstimate)
    
    val = window.tools.map(this.position, 0, this.durationEstimate, 0, Tapesfm.trackm.trackWidth)

    $(".track_position").css({"margin-left": (Number(val) - 42)})
    $("#scrabber_label").css({left: val})
    $("#scrabber_value").html(window.tools.toTime(this.position))

    _.each window.Tapesfm.trackm.tracks, (t) =>
      unless Number(val) > Number($(("#"+t.id+"_clip")).width())
        $(("#"+t.id+"_progress")).css({width: val})
      else
        $(("#"+t.id+"_progress")).css({width: $(("#track_"+t.id+"_clip")).width()})
    
      
   
  
  loading: ->
    baseWidth = Tapesfm.trackm.trackWidth
    tWidth = $(("#"+this.id+"_clip")).width()

    val = window.tools.map(this.bytesLoaded, 0, this.bytesTotal, 0, tWidth)
    
    percent = window.tools.map(this.bytesLoaded, 0, this.bytesTotal, 0, 100 )

    # @totalLoadingTracks = {}
    #@totalLoadingTracks = {} unless @totalLoadingTracks

    window.totalLoadingTracks[this.id] = percent
  
    window.loadingReady()

    # console.log "is ready ? = #{@loadingReady()}"
    # console.log("% loaded from total = " + @totalLoadingTracks[this.id] )

    # console.log "dd"
    $(("#"+this.id+"_loaded")).css({width: val})
    
    #val = window.tools.map(300, 0,400,0,1000)

  finish: ->
    #alert "end"
    Tapesfm.trackm.stop()





