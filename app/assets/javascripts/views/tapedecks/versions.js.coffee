class Tapesfm.Views.TapedeckVersions extends Backbone.View
  template: JST['tapedecks/versions']
  

    
  initialize: ->
  
  changeTape: (data) ->
    alert "dd"
  appendVersion: (version) ->
    #alert "dd"
    versionView = new Tapesfm.Views.TapedeckVersion(model: version)
    $('#tapedeck_versions').append(versionView.render().el)
  render: ->
    rendertContent = @template()
    $(@el).append(rendertContent)
    @collection.each @appendVersion
    this

