class Tapesfm.Views.Tape extends Backbone.View
  template: JST['tapes/tape']
  tag: "div"
  
  className: "tape"

  events:
    "click .settings_btn" : "openSettings"

  initialize: ->

    @model.on("change",@render, this)

  openSettings: (e) ->
    #settingView = new Tapesfm.Views.TapeSetting(model: @model)
    $("#setting-popin_#{@model.get("id")}").addClass("active")
    $(".popin-overlay").addClass("active")



    console.log "VALUE  " + $("#tags_#{@model.get("id")}").val()
    $(".popin-overlay").live "click", (e) ->
      if $(e.target).is('.popin-overlay')
        
        $(".popin-overlay").removeClass("active")

        $(".setting-popin").removeClass("active")

        $(".popin-overlay").die "click"

  addTags: (tags) ->
    if tags
      for tag in tags
        do (tag) =>
           @addTag tag
      

  addTag: (tag) ->
    $("#tags_#{@model.get("id")}").tagit("createTag", String(tag))

  removeOver: (e) ->
    alert "over"
    $("#setting-popin_#{@model.get("id")}").removeClass("active")

  initPopIn: (key) ->
  
    settingView = new Tapesfm.Views.TapeSetting(model: @model)

    # console.log @model.get("remixable")

    $("body").append("<div class='setting-popin' id='setting-popin_#{key}'></div>")
    $("body").find("#setting-popin_#{key}").html(settingView.render().el)
    $("body").find("#setting-popin_#{key} input:checkbox").iphoneStyle()
    $("body").find("#setting-popin_#{key} label").inFieldLabels()




  render: ->

    #tapdeck = new Tapesfm.Models.Tapedeck({remixable: true, commentable: true, public: true})
    
    
    #$(@el).html(settingView.render().el)

    #$(@el).remove()

    rendertContent = @template(model: @model)

    $(@el).html(rendertContent)
    @initPopIn(@model.get("id"))
    $(@el).attr('id', @model.get("id"))
    #$(@el).fadeIn(2000)
    $("#tags_#{@model.get("id")}").tagit
      placeholderText: "Click to add a tag"
      autocomplete: {source: "/api/tags",delay: 0, minLength: 1}
    
    $('ul.tagit input').alpha({nocaps:true, allow: "1234567890"})
    
    # @addTag "blaaa"
    @addTags @model.get("tags")



    this
