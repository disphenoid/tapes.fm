class Tapesfm.Views.User extends Backbone.View
  animationTime: []
  template: JST['user/user']
  events:
    "click .follow_btn" : "follow"

  follow: (e) ->
    
    # alert ($(e.currentTarget).data("following") == true)

    if $(e.currentTarget).data("following") == true

      follower = new Tapesfm.Models.Follower({follow: "false", id: $(e.currentTarget).data("id"), _id: $(e.currentTarget).data("id")})
      console.log follower
      follower.destroy()
      $(e.currentTarget).removeClass("inactive").html("Follow")
      $(e.currentTarget).data("following",false)
      
    else
      follower = new Tapesfm.Models.Follower({follow: "true", target_id: $(e.currentTarget).data("id")})
      follower.save()
      console.log follower

      $(e.currentTarget).addClass("inactive").html("Unfollow")
      $(e.currentTarget).data("following",true)


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




  appendTapedeck: (tapedeck) =>
    console.log tapedeck.get("name")
    tapedeckView = new Tapesfm.Views.Tape(model: tapedeck)
    #$(@el).append("ddd")
    $(@el).find("#tapes_list").append(tapedeckView.render().el)
    #$(@el).find(tapedeckView.render().el).fadeIn( @animationTime.pop)


    

  initPopIn: (key) -> 

    new_tapdeck = new Tapesfm.Models.Tapedeck({remixable: true, commentable: true, public: true})
    settingView = new Tapesfm.Views.TapeSetting(model: new_tapdeck)
    
    $("body").append("<div class='setting-popin' id='setting-popin_#{key}'></div>")

    $("body").find("#setting-popin_#{key}").append(settingView.render().el)

    $("body").find("#setting-popin_#{key} input:checkbox").iphoneStyle()

    $("body").find("#setting-popin_#{key} label").inFieldLabels() 

  appendFollower: (follower) ->
   if follower.get("picture")
    $(@el).find("#followers_list").append("<a href='/#{follower.get("name")}'><div class='follower tip' title='#{follower.get("name")}'> <img src='http://#{follower.get("picture")}'></img> </div></a>")
   else
    $(@el).find("#followers_list").append("<a href='/#{follower.get("name")}'><div class='follower tip' title='#{follower.get("name")}'> </div></a>")

  render: ->
    
    user = new Tapesfm.Models.User(Tapesfm.bootstrap.user)
    rendertContent = @template(is_following: Tapesfm.bootstrap.is_following, user: user)

    
    $(@el).html(rendertContent)

    @animationTime = []
    # @collection.each (tapedeck) =>
    #   @animationTime.push 1000

    @collection.each @appendTapedeck

    @follower_collection = new Tapesfm.Collections.Users(Tapesfm.bootstrap.user.followers)

    @follower_collection.each @appendFollower, this

    
    
    @initPopIn("new")


    this

