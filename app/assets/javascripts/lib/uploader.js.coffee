class window.Uploader
  id: "#upload_field"
  constructor: (id,tape_id) ->
    $("#tape_upload").hide()
    data = {}

    data.session_key = Tapesfm.crsf.uploadify_script_data._tapesfm_session
    data.authenticity_token = encodeURI(Tapesfm.crsf.uploadify_script_data.authenticity_token)
    
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length


    # if Tapesfm.bootstrap.active_tape_id
    #   data['tape_id'] = Tapesfm.bootstrap.active_tape_id
    # else
    #   data['tape_id'] = "0"

    $(id).uploadifive

      uploadScript      : '/upload'
      buttonText        : 'Upload File'
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
        #Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")

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

    data.session_key = Tapesfm.crsf.uploadify_script_data._tapesfm_session
    data.authenticity_token = encodeURI(Tapesfm.crsf.uploadify_script_data.authenticity_token)
    #data.csrf_token = authenticity_token
    #data.session_key = authenticity_token

    data['tape_id'] = id
    data['tapedeck_id'] = Tapesfm.bootstrap._id
    data['track_length'] = Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length
    

    #data['color'] = (Number(Tapesfm.tapedeck.tapedeck.get("tape").get("tracks").length) + 1)

    #$("#upload_field").uploadify('settings', "formData", data)
    #$("#upload_field").uploadifive('settings', "formData", data)
    $("#upload_field").uploadifive("destroy")
    $("#upload_field").uploadifive

      uploadScript          : '/upload'
      buttonText        : 'Upload File'
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
      onCancel: ->

        $("#tape_save_button").removeClass("wait")
        $("#tape_save_hint_sub").show()


      onError: ->

        $("#tape_save_button").removeClass("wait")
        $("#tape_save_hint_sub").show()

      onQueueComplete   : ->
        $("#tape_upload").hide()
        #$("#tape_save_button").show()
        $("#tape_save_button").removeClass("wait")
        $("#tape_save_hint_sub").show()
      onUpload   : ->
        $("#tape_upload").show("slow")
        Tapesfm.tapedeck.tapedeck.get("tape").trigger("new")
        $("#tape_save_button").addClass("wait")
        $("#tape_save_hint_sub").hide()
