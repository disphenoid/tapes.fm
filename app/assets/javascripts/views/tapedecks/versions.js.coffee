class Tapesfm.Views.TapedeckVersions extends Backbone.View
  template: JST['tapedecks/versions']
    
  initialize: ->
    @model.get("tape").on('change:id', @newTapeMode, this)
    $("#tapedeck_versions").slideToggle(0)


    $("#tape_select_button, #tapedeck_current_version, .tape_version_el").live "click", ->
      unless $("#tapedeck_versions").is(':visible')
        $("#tapedeck_versions").animate({opacity: "toggle",height: "toggle"}, 200)
        $("#version_list").animate({top: 40}, 200)
      else
        $("#tapedeck_versions").animate({opacity: "toggle",height: "toggle"}, 200)
        $("#version_list").animate({top: 0}, 200)
  
  newTapeMode: (data) ->
    if !@model.get("tape").isNew()
      $('#tapedeck_versions').show()
      $('#edit_mode').hide()

  appendVersion: (version) ->
    #alert "dd"
    versionView = new Tapesfm.Views.TapedeckVersion(model: version)
    $('#tapedeck_versions').append(versionView.render().el)
  render: ->
    #unless @model.get("tape").isNew()

    rendertContent = @template()
    $(@el).html(rendertContent)
    @model.get("versions").each @appendVersion
    
    editView = new Tapesfm.Views.TapedeckEdit(model: @model)
    this.$('#edit_mode').html(editView.render().el)


    this

