class Tapesfm.Views.User extends Backbone.View
  animationTime: []
  template: JST['user/user']
  events:
    "click .add_tape" : "addTape"

  initialize: ->
    
    @collection.on('add', @prependTapedeck, this)
    @collection.on('remove', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)
    Tapesfm.tapes = @collection

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
    #$(@el).find(tapedeckView.render().el).fadeIn( @animationTime.pop)

  prependTapedeck: (tapedeck) =>
    console.log tapedeck.get("name")
    tapedeckView = new Tapesfm.Views.Tape(model: tapedeck)
    #$(@el).append("ddd")
    $(@el).find("#tapes_list").prepend(tapedeckView.render().el)
    $(@el).find(tapedeckView.render().el).hide().fadeIn("slow")
    

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

    @animationTime = []
    # @collection.each (tapedeck) =>
    #   @animationTime.push 1000

    @collection.each @appendTapedeck
    
    
    @initPopIn("new")


    this

