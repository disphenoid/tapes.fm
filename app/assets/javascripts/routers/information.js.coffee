class Tapesfm.Routers.Information extends Backbone.Router
  routes:
    'start' : 'start'
    'about' : 'about'
    'faq' : 'faq'
    'terms' : 'terms'


  initialize: ->
    #console.log "init routes"

  start: (id) ->
    view = new Tapesfm.Views.InfoStart()
    $('#information').html(view.render().el)
    @active "start"
    # $('#container').html(view.render().el)
  about: (id) ->
    view = new Tapesfm.Views.InfoAbout()
    $('#information').html(view.render().el)
    @active "about"
    # $('#container').html(view.render().el)
  faq: (id) ->
    view = new Tapesfm.Views.InfoFAQ()
    $('#information').html(view.render().el)
    @active "faq"
    # $('#container').html(view.render().el)

  terms: (id) ->
    view = new Tapesfm.Views.InfoTerms()
    $('#information').html(view.render().el)
    @active "terms"
    # $('#container').html(view.render().el)
    #
  active: (active_is) ->

    $('.nav_el').removeClass("active")
    $("#nav_#{active_is}").addClass("active")

