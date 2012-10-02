class Tapesfm.Views.TapedeckComments extends Backbone.View
  template: JST['tapedecks/comments']
  events: ->
    "click #send_button" : "createComment"
    "focus #comment_field" : "focusField"
    "blur #comment_field" : "blurField"
  initialize: ->
    @collection.on("add", @appendComment,this)
    @collection.on("reset", @render,this)
    @collection.on("remove", @removeComment,this)

    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    $(@el).find("#send_button").hide()
    

  focusField: (e) =>
    $("#send_button").fadeIn("slow")
    unless $(e.currentTarget).height() > 80
      $(e.currentTarget).animate({height: 80})

  blurField: (e) =>
    if $(e.currentTarget).val() == ""
      $("#send_button").fadeOut("fast")
      $(e.currentTarget).animate({height: 24})

  removeComment: (comment) ->

    $(".comment##{comment.get("id")}").hide "slow", ->
     $(this).remove()


  createComment: (e) ->
    if $("#comment_field").val() != ""
      comment = new Tapesfm.Models.Comment()
      comment.set({tapedeck_id: Tapesfm.tapedeck.tapedeck.get("id")})
      comment.set({tape_id: Tapesfm.tapedeck.tapedeck.get("active_tape_id")})
      comment.set({body: $("#comment_field").val()})
      comment.set({user_name: Tapesfm.user.name})
      comment.save()

      @collection.add(comment)

      $("#comment_field").val("").focus().blur()
    #Tapesfm.tapedeck.tapedeck.get("comments").fetch()

    #@commentlection.fet
  appendComment: (comment) ->
    commentView = new Tapesfm.Views.TapedeckComment(model: comment)
    $('.comments').prepend(commentView.render().el)


  render: ->

    #$(@el).fadeIn(2000)
    #$('.comments').html("")

    @collection.each @appendComment
    this



