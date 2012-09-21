class window.Uploader
  id: "#upload_field"
  constructor: (id,tape_id) ->

    data = Tapesfm.crsf.uploadify_script_data
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length

    $("#tape_upload").hide()

    if Tapesfm.bootstrap.active_tape_id
      data['tape_id'] = Tapesfm.bootstrap.active_tape_id
    else
      data['tape_id'] = "0"

    $(id).uploadifive

      uploadScript      : '/upload'
      buttonText        : 'From File'
      buttonCursor      : 'hand'
      auto              : true
      multi             : true
      removeCompleted   : true
      queueSizeLimit    : 8
      removeTimeout     : 0
      onUploadComplete  : window.onUploadComplete
      formData          : data
      buttonClass       : "from_file_zzz"
      height            : 40
      width             : 150
      queueID           : "tape_upload"
      onQueueComplete   : ->
        $("#tape_upload").hide()
      onUpload          : ->
        $("#tape_upload").show("slow")

  onUploadComplete: (file, data, response) ->
    #alert "complete"
    console.log file
    console.log(data)
    track_json = jQuery.parseJSON( data)

    Tapesfm.tapedeck.newTapeWithTrack track_json.track
    console.log("responds"+response)

  onUploadError: (file, errorCode, errorMsg, errorString) ->
    alert('The file ' + file.name + ' could not be uploaded: ' + errorString)
    console.log errorCode
    console.log errorMsg
  setting: (att,value) ->
    $("#upload_field").uploadifive('settings', att, value)
  destroy: ->
    $("#upload_field").uploadifive("destroy")


  setTape: (id) ->
    
    data = {}
    data = Tapesfm.crsf.uploadify_script_data
    data['tape_id'] = id
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length
    #data['color'] = (Number(Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length) + 1)

    #$("#upload_field").uploadify('settings', "formData", data)
    #$("#upload_field").uploadifive('settings', "formData", data)
    $("#upload_field").uploadifive("destroy")
    $("#upload_field").uploadifive

      uploadScript          : '/upload'
      buttonText        : 'From File'
      buttonCursor      : 'hand'
      auto              : true
      multi             : true
      removeCompleted   : true
      queueSizeLimit    : 8
      removeTimeout     : 0
      onUploadComplete   : window.onUploadComplete
      formData          : data
      buttonClass       : "from_file_zzz"
      height            : 40
      width             : 150
      queueID           : "tape_upload"
      onQueueComplete   : ->
        $("#tape_upload").hide()
      onUpload   : ->
        $("#tape_upload").show("slow")
