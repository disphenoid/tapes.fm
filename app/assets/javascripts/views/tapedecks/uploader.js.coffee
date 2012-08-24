class Tapesfm.Views.TapedeckUploader extends Backbone.View
  template: JST['tapedecks/uploader']

  initialize: ->
  
  render: ->
    rendertContent = @template(token: Tapesfm.crsf.token, id: @model.get("_id"))
    $(@el).html(rendertContent)
    #$(@el).fadeIn(200)
    #@mainUploader = new Uploader "upload_field"
    this
