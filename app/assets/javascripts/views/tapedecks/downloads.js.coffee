class Tapesfm.Views.TapedeckDownloads extends Backbone.View
  template: JST['tapedecks/downloads']
  

  initialize: ->

  appendDownload: (download) ->
    downloadView = new Tapesfm.Views.TapedeckDownload(model: download, className: "download_el c#{download.get("color")}")
    this.$('#download_body').append(downloadView.render().el)

  render: ->

    #$(@el).fadeIn(2000)
    #$('.comments').html("")
    $('#download_body').html("")
    @collection.each @appendDownload
    this




