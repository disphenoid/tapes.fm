class Tapesfm.Views.TapedeckVersions extends Backbone.View
  template: JST['tapedecks/versions']
  
  initialize: ->
    @model.get("tape").on('change:id', @newTapeMode, this)
    @model.get("tape").on('change:_id', @renderCurrentTape, this)

    #$("#tapedeck_versions").slideToggle(0)

    $("#tape_select_button, #tapedeck_current_version, .tape_version_el").live "click", ->
      unless $("#tapedeck_versions").is(':visible')
        $("#tapedeck_versions").animate({opacity: 1,height: "toggle"}, 200)
        $("#version_list").animate({top: 40}, 200)
        $("#tape_select").addClass("open")
        $(".active_version").hide()
      else
        $("#tapedeck_versions").animate({opacity: 0,height: "toggle"}, 200)
        $("#version_list").animate({top: 0}, 100)
        $("#tape_select").removeClass("open")
        $(".active_version").show()
  
  newTapeMode: (data) ->
    if !@model.get("tape").isNew()
      $('#tape_select').css("display","inline-block")
      $('#tape_edit_modul').css("display","none")
    else
      $('#tape_select').css("display","none")
      $('#tape_edit_modul').css("display","inline-block")


  appendVersion: (version) ->
    #alert "dd"
    versionView = new Tapesfm.Views.TapedeckVersion(model: version)
    $('#tapedeck_versions').append(versionView.render().el)

  renderCurrentTape: ->
    
    unless @model.get("tape").isNew()
      rendertContent = @template(tape: @model.get("tape"))
      $(@el).html(rendertContent)
      $('#tapedeck_versions').show()
      $('.version').removeClass("active")
      $("#version_#{@model.get("tape").get("_id")}").addClass("active")
    this
    

  render: ->
    #unless @model.get("tape").isNew()

    rendertContent = @template(tape: @model.get("tape"))
    $(@el).html(rendertContent)
    @model.get("versions").each @appendVersion
    
    #editView = new Tapesfm.Views.TapedeckEdit(model: @model)
    #this.$('#edit_mode').html(editView.render().el)
    $('.version').removeClass("active")
    $("#version_#{@model.get("tape").get("_id")}").addClass("active")

    this

