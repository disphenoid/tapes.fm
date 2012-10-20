class Tapesfm.Views.Tapes extends Backbone.View
  template: JST['tapes/tapes']
  events:
    "click .add_tape" : "addTape"


  initialize: ->
    
    #@model.on('change', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)

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
    console.log tapedeck.get("name")
    tapedeckView = new Tapesfm.Views.Tape(model: tapedeck)
    #$(@el).append("ddd")
    $(@el).find("#tapes_list").append(tapedeckView.render().el)
  

  initPopIn: (key) ->
  
    new_tapdeck = new Tapesfm.Models.Tapedeck({remixable: true, commentable: true, public: true})
    settingView = new Tapesfm.Views.TapeSetting(model: new_tapdeck)
    
    $("body").append("<div class='setting-popin' id='setting-popin_#{key}'></div>")

    $("body").find("#setting-popin_#{key}").append(settingView.render().el)

    $("body").find("#setting-popin_#{key} input:checkbox").iphoneStyle()

    $("body").find("#setting-popin_#{key} label").inFieldLabels()


  


  render: ->
    
    
    rendertContent = @template()

    
    $(@el).html(rendertContent)

    @collection.each @appendTapedeck
    
    
    @initPopIn("new")


    #$(@el).fadeIn(2000)
    #
    
    
    #$(@el).html(settingView.render().el)



     

    this
