class window.Uploader
  id: "#upload_field"
  constructor: (id) ->

    data = Tapesfm.crsf.uploadify_script_data
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length

    if Tapesfm.bootstrap.active_tape_id
      data['tape_id'] = Tapesfm.bootstrap.active_tape_id
    else
      data['tape_id'] = "0"

    $(id).uploadify

      swf               : '/assets/uploadify.swf'
      uploader          : '/upload'
      buttonText        : 'From File'
      buttonCursor      : 'hand'
      auto              : true
      multi             : false
      removeCompleted   : true
      onUploadSuccess   : @onUploadComplete
      onUploadError     : @onUploadError
      formData          : data
      buttonClass       : "from_file"
      height            : 40
      width             : 150

  onUploadComplete: (file, data, response) ->
    #alert "complete"
    console.log file
    console.log(data)
    track_json = jQuery.parseJSON( data)

    Tapesfm.tapedeck.newTapeWidthTrack track_json
    console.log("responds"+response)

  onUploadError: (file, errorCode, errorMsg, errorString) ->
    alert('The file ' + file.name + ' could not be uploaded: ' + errorString)
    console.log errorCode
    console.log errorMsg
  setting: (att,value) ->
    $("#upload_field").uploadify('settings', att, value)
  destroy: ->
    $("#upload_field").uploadify("destroy")
  setTape: (id) ->
    data = {}
    data = Tapesfm.crsf.uploadify_script_data
    data['tape_id'] = id
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length
    #data['color'] = (Number(Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length) + 1)

    $("#upload_field").uploadify('settings', "formData", data)
    
    

