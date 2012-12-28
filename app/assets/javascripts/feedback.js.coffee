sending_feedback = false
jQuery ->
  $("#feedback_label").inFieldLabels()
  $("#feedback_button").click (e) ->
    $(".feedback_bg").fadeIn()
    $("#feedback_button").fadeOut()
    # $(".feedback").fadeIn()
    $(".feedback").addClass("active")
    $("#feedback_field").focus()
  $(".feedback_bg").click (e) ->
    $(".feedback_bg").fadeOut()
    $(".feedback").removeClass("active")
    $("#feedback_button").fadeIn()
  $("#send_feedback").click ->
    unless sending_feedback
      sending_feedback = true
      $("#send_feedback").html("Sending...").addClass("loading")
      $.ajax
        url: "/api/feedbacks"
        type: "post"
        data: {"body": $("#feedback_field").val()}
        success: (response, textStatus, jqXHR) ->
          $("#feedback_field").val("").focus().blur()
          $(".feedback_bg").fadeOut()
          $(".feedback").removeClass("active")
          $("#feedback_button").fadeIn()
        
        error: (jqXHR, textStatus, errorThrown) ->
        complete: () ->
          sending_feedback = false
          $("#send_feedback").html("Send").removeClass("loading")
