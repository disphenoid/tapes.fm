class Tapesfm.Views.Tapes extends Backbone.View
  animationTime: []
  template: JST['tapes/tapes']
  events:
    "click .add_tape" : "createNewTape"

  initialize: ->
    
    @collection.on('add', @prependTapedeck, this)
    @collection.on('remove', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)
    Tapesfm.tapes = @collection



  createNewTape: ->

    tapedeck = new Tapesfm.Models.Tapedeck
    settingId = "new"

    tapedeck.set({name: $("#tape_name_field_#{settingId}").val(), remixable: true, commentable: true, public: true })

    tapedeck.save(
      {}
      {success: (model, response) ->
        #console.log "response " + response.id
        #window.location = "/tapedeck/"+response._id
        tapedeck = new Tapesfm.Models.Tapedeck(response)
        tapedeck.set({id: response._id})

        Tapesfm.tapes.unshift(tapedeck)
        $(".hint").fadeOut("slow")


      })





  removeNew: (e) ->
    if $(e.target).is('.popin-overlay')
      $(".popin-overlay").removeClass("active")
      $("#setting-popin_#{"new"}").removeClass("active")


  addTape: (e) ->
    
    $("#setting-popin_#{"new"}").addClass("active")
    $(".popin-overlay").addClass("active")
    $(".popin-overlay").live "click", (e) ->
      if $(e.target).is('.popin-overlay')
        
        $(".popin-overlay").removeClass("active")

        $(".setting-popin").removeClass("active")

        $(".popin-overlay").die "click"

  appendTapedeck: (tapedeck) =>
    # console.log tapedeck.get("name")
    tapedeckView = new Tapesfm.Views.Tape(model: tapedeck)
    #$(@el).append("ddd")
    $(@el).find("#tapes_list").append(tapedeckView.render().el)
    $(@el).find("#tapedeck_name_#{tapedeck.get("id")}").fadeTo(100,0.5)
    $(@el).find(tapedeckView.render().el).css("display":"inline-block")

    #$(@el).find(tapedeckView.render().el).fadeIn( @animationTime.pop)

  prependTapedeck: (tapedeck) =>
    # console.log tapedeck.get("name")
    tapedeckView = new Tapesfm.Views.Tape(model: tapedeck)
    #$(@el).append("ddd")
    $(@el).find("#tapes_list").prepend(tapedeckView.render().el)
    # $(@el).find(tapedeckView.render().el).hide().fadeIn("slow")
    # $(@el).find("##{tapedeck.get("id")}").hide().show("slow")
    #

    $(@el).find("##{tapedeck.get("id")}").css("display":"inline-block", "width": 0, "opacity": 0).animate({width: 140}, 100).fadeTo(100,1)

    tapedeck.trigger("settings")
    

  initPopIn: (key) ->

    new_tapdeck = new Tapesfm.Models.Tapedeck({remixable: true, commentable: true, public: true})
    settingView = new Tapesfm.Views.TapeSetting(model: new_tapdeck)
    
    $("body").append("<div class='setting-popin' id='setting-popin_#{key}'></div>")

    $("body").find("#setting-popin_#{key}").append(settingView.render().el)

    $("body").find("#setting-popin_#{key} input:checkbox").iphoneStyle()

    $("body").find("#setting-popin_#{key} label").inFieldLabels()

  render: ->
    if @collection.length == 0
      @noob = true 
    else
      @noob = false
    
    rendertContent = @template(noob: @noob)


    $(@el).html(rendertContent)

    @animationTime = []

    @collection.each @appendTapedeck
    @initPopIn("new")


    this
