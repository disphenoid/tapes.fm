class window.Uploader
  id: "#upload_field"
  constructor: (id) ->

    data = Tapesfm.crsf.uploadify_script_data
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['tape_id'] = Tapesfm.bootstrap.active_tape_id

    $(id).uploadify

      swf               : '/assets/uploadify.swf'
      uploader          : '/upload'
      buttonText        : 'Add Tracks'
      buttonCursor      : 'hand'
      height            : 20
      auto              : true
      multi             : true
      removeCompleted   : true
      onUploadComplete  : @onUploadComplete
      onUploadError     : @onUploadError
      formData          : data

  onUploadComplete: (file) ->
    alert "complete"
  onUploadError: (file, errorCode, errorMsg, errorString) ->
    alert('The file ' + file.name + ' could not be uploaded: ' + errorString)
  setting: (att,value) ->
    $("#upload_field").uploadify('settings', att, value)
  destroy: ->
    $("#upload_field").uploadify("destroy")
  setTape: (id) ->

    data = Tapesfm.crsf.uploadify_script_data
    data['tape_id'] = id
    $("#upload_field").uploadify('settings', "formData", data)
    
    

