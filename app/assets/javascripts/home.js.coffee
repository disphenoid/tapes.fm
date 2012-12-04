# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

c1 = "#ffffff"
c2 = "#fcfcfc"
c3 = "#f9f9f9"
c4 = "#f6f6f6"
aniTime = 200


jQuery () ->

  $(".beta_button").click (e) ->
    #console.log "dd"
    $("#beta_form").animate({height: 105}, 400, "easeOutQuart")
    $("#email").focus()
    $("#overlay").addClass("active")
  $("#overlay").click (e) ->
    $("#beta_form").animate({height: 0}, 400, "easeOutQuart")
    $("#overlay").removeClass("active")


  $("#col1").mouseenter (e) ->
    $("#screen1").fadeIn(aniTime)
    $("#screen2").fadeOut(aniTime)
    $("#screen3").fadeOut(aniTime)
    $("#screen4").fadeOut(aniTime)
    
    $("#nav_back").animate({left: 0}, 0)

  $("#col2").mouseenter (e) ->
    $("#screen1").fadeOut(aniTime)
    $("#screen2").fadeIn(aniTime)
    $("#screen3").fadeOut(aniTime)
    $("#screen4").fadeOut(aniTime)

    $("#nav_back").animate({left: 230}, 0)

  $("#col3").mouseenter (e) ->
    $("#screen1").fadeOut(aniTime)
    $("#screen2").fadeOut(aniTime)
    $("#screen3").fadeIn(aniTime)
    $("#screen4").fadeOut(aniTime)

    $("#nav_back").animate({left: 460}, 0)

  $("#col4").mouseenter (e) ->
    $("#screen1").fadeOut(aniTime)
    $("#screen2").fadeOut(aniTime)
    $("#screen3").fadeOut(aniTime)
    $("#screen4").fadeIn(aniTime)

    $("#nav_back").animate({left: 690},0)

  # $("#col1").mouseenter (e) ->
  #   #$(".home_left, .home_right, .col").removeClass("s1").removeClass("s2").removeClass("s3").removeClass("s4")

  #    $(".home_left").animate({backgroundColor: c1}) #s1
  #    $("#col1").animate({backgroundColor: c1},aniTime) #s1
  #    $("#col2").animate({backgroundColor: c2},aniTime) #s2
  #    $("#col3").animate({backgroundColor: c3},aniTime) #s3
  #    $("#col4").animate({backgroundColor: c4},aniTime) #s4
  #    $(".home_right").animate({backgroundColor: c4},aniTime) #s4

  # $("#col2").mouseenter (e) ->
  #   # $(".home_left, .home_right, .col").removeClass("s1").removeClass("s2").removeClass("s3").removeClass("s4")

  #   $(".home_left").animate({backgroundColor: c2},aniTime) #s2
  #   $("#col1").animate({backgroundColor: c2},aniTime) #s2
  #   $("#col2").animate({backgroundColor: c1}) #s1
  #   $("#col3").animate({backgroundColor: c2},aniTime) #s2
  #   $("#col4").animate({backgroundColor: c3},aniTime) #s3 
  #   $(".home_right").animate({backgroundColor: c3},aniTime) #s3



  # $("#col3").mouseenter (e) ->
  #   #$(".home_left, .home_right, .col").removeClass("s1").removeClass("s2").removeClass("s3").removeClass("s4")

  #   $(".home_left").animate({backgroundColor: c3},aniTime) #s3
  #   $("#col1").animate({backgroundColor: c3},aniTime) #s3
  #   $("#col2").animate({backgroundColor: c2},aniTime) #s2
  #   $("#col3").animate({backgroundColor: c1},aniTime) #s1

  #   $("#col4").animate({backgroundColor: c2},aniTime) #s2

  #   $(".home_right").animate({backgroundColor: c2},aniTime) #s2


  # $("#col4").mouseenter (e) ->
  #   #$(".home_left, .home_right, .col").removeClass("s1").removeClass("s2").removeClass("s3").removeClass("s4")

  #   $(".home_left").animate({backgroundColor: c4},aniTime) #s4 
  #   $("#col1").animate({backgroundColor: c4},aniTime) #s4 
  #   $("#col2").animate({backgroundColor: c3},aniTime) #s3 
  #   $("#col3").animate({backgroundColor: c2},aniTime) #s2 
  #   $("#col4").animate({backgroundColor: c1},aniTime) #s1 
  #   $(".home_right").animate({backgroundColor: c1},aniTime) #s1

